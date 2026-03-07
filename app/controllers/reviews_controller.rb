class ReviewsController < ApplicationController
  before_action :set_review, only: [:update, :destroy]
  before_action :set_book, only: [:index, :create]
  skip_before_action :authenticate_request, only: [:index]
  before_action :authorize_review!, only: [:update, :destroy]

  # GET /books/:book_id/reviews
  def index
    cache_key = "book_#{@book.id}_reviews"
    reviews = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      @book.reviews.includes(:user).to_a
    end

    render json: reviews.as_json(include: { user: { only: [:id, :username] } })
  end

  # POST /books/:book_id/reviews
  def create
    @review = @book.reviews.build(review_params)
    @review.user = current_user

    if @review.save
      clear_reviews_cache
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reviews/:id
  def update
    if @review.update(review_params)
      clear_reviews_cache
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reviews/:id
  def destroy
    @review.destroy
    clear_reviews_cache
    head :no_content
  end

  private

  def clear_reviews_cache
    Rails.cache.delete("book_#{@book.id}_reviews")
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def authorize_review!
    head :forbidden unless @review.user_id == current_user.id
  end
end