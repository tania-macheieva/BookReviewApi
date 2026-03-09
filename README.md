# Book Review API

## Table of Contents

- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
  - [Authentication](#authentication)
  - [Books](#books)
  - [Reviews](#reviews)
- [Features](#features)

## Overview

REST API for managing books and user reviews.

Users can create books, write reviews, search books, and view ratings.
The API supports authentication, pagination, sorting, caching, and rate limiting.

## Tech Stack

* Ruby on Rails
* PostgreSQL
* Redis
* Docker

---

## Installation

## Clone the repository

```bash
git clone https://github.com/tania-macheieva/BookReviewApi.git
cd BookReviewApi
```

## Create environment file

Create a `.env` file in the project root.

Example:

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_password
POSTGRES_DB=book_review

SECRET_KEY_BASE=your_secret_key_base
RAILS_MAX_THREADS=5

REDIS_URL=redis://redis:6379/0

DATABASE_URL=postgres://postgres:your_password@db:5432/book_review
```

## Run the application

```bash
docker compose up --build
```

The API will be available at:

```
http://localhost:3000
```

---

## Database Schema

Relations:

* A user can create many books
* A user can create many reviews
* A book can have many reviews
* A review belongs to a user and a book

## Database Diagram
<img width="961" height="363" alt="image" src="https://github.com/user-attachments/assets/59f0b96e-0d51-4812-956b-3b6233ddc8b2" />

---

## API Endpoints

## Authentication

Register

```
POST /register
```

Login

```
POST /login
```

Response:

```json
{
  "token": "jwt_token"
}
```

---

## Books

Get books

```
GET /books
```

Query parameters:

```
page
per_page
search
sortBy
order
```

Get a single book

```
GET /books/:id
```

Create book

```
POST /books
```

Request body:

```json
{
  "title": "Rails",
  "author": "Andrew",
  "description": "Master Rails"
}
```

Update book

```
PATCH /books/:id
```

Delete book

```
DELETE /books/:id
```

---

## Reviews

Create review

```
POST /books/:book_id/reviews
```

Request body:

```json
{
  "rating": 5,
  "comment": "Great book"
}
```

---

## Features

* JWT authentication
* search by title and author
* pagination and sorting
* caching with Redis
* HTTP caching (ETag / stale?)
* rate limiting
* Docker environment
