class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show]
  before_action :authorize_book!, only: [:update, :destroy]

  # GET /books
  def index
    cache_key = "books_index_#{params[:page]}_#{params[:per_page]}_#{params[:search]}_#{params[:sortBy]}_#{params[:order]}"
    books = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      BooksQuery.new(params).call.to_a
    end

    if stale?(books, last_modified: books.map(&:updated_at).max)
      render json: books
    end
  end

  # GET /books/:id
  def show
    if stale?(@book, last_modified: @book.updated_at)
      reviews = Rails.cache.fetch("book_#{@book.id}_reviews", expires_in: 10.minutes) do
        @book.reviews.includes(:user).to_a
      end

      render json: @book.as_json(include: { reviews: { only: [:id, :rating, :comment], include: { user: { only: [:id, :username] } } } })
    end
  end

  # POST /books
  def create
    book = Book.new(book_params)
    book.user = current_user

    if book.save
      clear_books_cache
      render json: book, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/:id
  def update
    if @book.update(book_params)
      clear_books_cache
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book.destroy
    clear_books_cache
    head :no_content
  end

  private

  def clear_books_cache
    Rails.cache.delete_matched("books_index_*")
    Rails.cache.delete("book_#{@book.id}")
    Rails.cache.delete("book_#{@book.id}_reviews")
  end

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description)
  end

  def authorize_book!
    head :forbidden unless @book.user_id == current_user.id
  end
end