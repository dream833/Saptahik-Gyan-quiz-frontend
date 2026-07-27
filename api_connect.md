# 📡 App API Reference — Full Endpoints

> Complete list of all **App API endpoints** for Flutter mobile app integration.
>
> **Method:** All endpoints use **POST** with JSON body (except `update-profile.php` which uses multipart/form-data).
>
> **Auth:** No token required. User identified by `user_id` field.

---

## 📍 Base URL

```
https://saptahikgyan.space/wb-admin
```

All endpoints below are appended to this base URL.

---

## 1. Authentication

### 1.1 🔐 User Login
```
POST https://saptahikgyan.space/wb-admin/Api/app/login.php
```

**Request:**
```json
{
  "mobile": "9876543210",
  "password": "user_password"
}
```

**Response:**
```json
{
  "status": true,
  "message": "Login Successful",
  "user": {
    "id": "1",
    "name": "User Name",
    "email": "user@example.com",
    "mobile": "9876543210"
  }
}
```

---

### 1.2 📝 User Sign Up
```
POST https://saptahikgyan.space/wb-admin/Api/app/signup.php
```

**Request:**
```json
{
  "full_name": "New User",
  "email": "user@example.com",
  "mobile": "9876543210",
  "password": "secure_password"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "user_id": 1,
    "full_name": "New User",
    "email": "user@example.com",
    "mobile": "9876543210"
  }
}
```

---

## 2. Profile

### 2.1 👤 Get Profile
```
POST https://saptahikgyan.space/wb-admin/Api/app/fetch-profile.php
```

**Request:**
```json
{
  "user_id": 1
}
```

**Response:**
```json
{
  "status": true,
  "message": "Profile fetched successfully",
  "data": {
    "id": 1,
    "full_name": "Learner",
    "email": "learner@example.com",
    "mobile": "9876543210",
    "address": "123 Street",
    "class_grade": "10",
    "about_me": "Student",
    "profile_image": "uploads/profile/user_1_123.jpg",
    "created_at": "2025-01-01 00:00:00"
  }
}
```

---

### 2.2 ✏️ Update Profile
```
POST https://saptahikgyan.space/wb-admin/Api/app/update-profile.php
```
*(multipart/form-data)*

| Field | Type | Required |
|-------|------|----------|
| `user_id` | int | ✅ Yes |
| `full_name` | string | ✅ Yes |
| `email` | string | ✅ Yes |
| `mobile` | string | ✅ Yes |
| `address` | string | ❌ No |
| `class_grade` | string | ❌ No |
| `about_me` | string | ❌ No |
| `profile_image` | file | ❌ No |

**Response:**
```json
{
  "status": true,
  "message": "Profile updated successfully"
}
```

---

## 3. Dashboard

### 3.1 📊 Get User Dashboard
```
POST https://saptahikgyan.space/wb-admin/Api/app/dashboard.php
```

**Request:**
```json
{
  "user_id": 1
}
```

**Response:**
```json
{
  "data": {
    "user": {
      "name": "User Name",
      "email": "user@example.com",
      "phone": "9876543210"
    },
    "stats": {
      "total_tests_taken": 15,
      "average_score": 72,
      "total_correct": 120,
      "total_wrong": 30
    },
    "daily_quiz_available": true,
    "banners": [
      {
        "title": "Daily Quiz Challenge",
        "subtitle": "Test your knowledge with today's quiz",
        "icon": "quiz",
        "gradient": "primary"
      }
    ],
    "previous_test_records": [
      {
        "name": "Daily Quiz 1",
        "date": "2026-06-12 10:00:00",
        "total_questions": 10,
        "score": 80
      }
    ]
  }
}
```

---

## 4. Daily Mock Tests

### 4.1 🏫 Get Classes (with daily tests)
```
POST https://saptahikgyan.space/wb-admin/Api/app/daily-test/classes.php
```

**Request:** `{}` (empty)

**Response:**
```json
{
  "data": [
    { "id": 9,  "name": "9" },
    { "id": 10, "name": "10" }
  ]
}
```

---

### 4.2 📖 Get Subjects (with daily tests)
```
POST https://saptahikgyan.space/wb-admin/Api/app/daily-test/subjects.php
```

**Request:**
```json
{ "class_id": 10 }
```

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "Bangla" },
    { "id": 2, "name": "English" }
  ]
}
```

---

### 4.3 📋 Get Available Daily Tests
```
POST https://saptahikgyan.space/wb-admin/Api/app/daily-test/tests.php
```

**Request:**
```json
{
  "class_id": 10,
  "subject_id": 1
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Daily Quiz 1",
      "description": "Basic concepts from today's lessons",
      "total_questions": 10,
      "time_seconds": 200,
      "mark_per_question": 2
    }
  ]
}
```

---

### 4.4 ▶️ Start Daily Test (Get Questions)
```
POST https://saptahikgyan.space/wb-admin/Api/app/daily-test/start.php
```

**Request:**
```json
{
  "test_id": 1,
  "class_id": 10,
  "subject_id": 1
}
```

**Response:**
```json
{
  "data": {
    "test_id": 1,
    "time_seconds": 200,
    "questions": [
      {
        "id": 1,
        "text": "What is the capital of Bangladesh?",
        "options": ["Dhaka", "Chittagong", "Khulna", "Rajshahi"],
        "correct_index": 0
      }
    ]
  }
}
```

> **correct_index mapping:** A=0, B=1, C=2, D=3

---

## 5. All Mock Tests (Set-Based)

### 5.1 🏫 Get Classes (with test sets)
```
POST https://saptahikgyan.space/wb-admin/Api/app/all-tests/classes.php
```

**Request:** `{}` (empty)

**Response:**
```json
{
  "data": [
    { "id": 9,  "name": "9",   "grade": "9",   "has_tests": true },
    { "id": 10, "name": "10",  "grade": "10",  "has_tests": true }
  ]
}
```

---

### 5.2 📖 Get Subjects (with test sets)
```
POST https://saptahikgyan.space/wb-admin/Api/app/all-tests/subjects.php
```

**Request:**
```json
{ "class_id": 10 }
```

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "Bangla" },
    { "id": 2, "name": "English" }
  ]
}
```

---

### 5.3 📑 Get Chapters (with test sets)
```
POST https://saptahikgyan.space/wb-admin/Api/app/all-tests/chapters.php
```

**Request:**
```json
{
  "class_id": 10,
  "subject_id": 1
}
```

**Response:**
```json
{
  "data": [
    { "id": 1, "name": "Chapter 1" },
    { "id": 2, "name": "Chapter 2" }
  ]
}
```

---

### 5.4 📦 Get Test Sets
```
POST https://saptahikgyan.space/wb-admin/Api/app/all-tests/sets.php
```

**Request:**
```json
{
  "class_id": 10,
  "subject_id": 1,
  "chapter_id": 1
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Set-1",
      "total_questions": 10,
      "total_time": 20
    }
  ]
}
```

---

### 5.5 ▶️ Start Set Test (Get Questions)
```
POST https://saptahikgyan.space/wb-admin/Api/app/all-tests/start-set.php
```

**Request:**
```json
{
  "set_id": 1,
  "class_id": 10,
  "subject_id": 1,
  "chapter_id": 1
}
```

**Response:**
```json
{
  "data": {
    "set_id": 1,
    "time_seconds": 1200,
    "questions": [
      {
        "id": 101,
        "text": "Question text here?",
        "options": ["Option A", "Option B", "Option C", "Option D"],
        "correct_index": 0
      }
    ]
  }
}
```

---

## 6. Submit & Review Tests

### 6.1 ✅ Submit Test Answers
```
POST https://saptahikgyan.space/wb-admin/Api/app/submit-mocktest.php
```

**Request:**
```json
{
  "user_id": 1,
  "test_id": 1,
  "answers": {
    "1": "B",
    "2": "A",
    "3": "D"
  }
}
```
> `answers` is an object with `question_id` as key and selected letter (A/B/C/D) as value.

**Response:**
```json
{
  "status": true,
  "message": "Test submitted successfully",
  "data": {
    "score": 16,
    "correct": 8,
    "wrong": 1,
    "total_questions": 9
  }
}
```

---

### 6.2 🔍 Check Test Answers
```
POST https://saptahikgyan.space/wb-admin/Api/app/check-mock-answer.php
```

**Request:**
```json
{
  "user_id": 1,
  "test_id": 1
}
```

**Response:**
```json
{
  "status": true,
  "data": [
    {
      "question_id": 1,
      "question": "Question text",
      "option_a": "Option A",
      "option_b": "Option B",
      "option_c": "Option C",
      "option_d": "Option D",
      "selected_answer": "B",
      "correct_answer": "B",
      "is_correct": true
    }
  ]
}
```

---

### 6.3 📜 Test History
```
POST https://saptahikgyan.space/wb-admin/Api/app/test/history.php
```

**Request:**
```json
{
  "user_id": 1,
  "page": 1,
  "limit": 20
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Daily Quiz 1",
      "date": "2026-06-12 10:00:00",
      "total_questions": 10,
      "score": 8,
      "total_marks": 20,
      "percentage": 80.00
    }
  ]
}
```

---

## 7. Solution Hub – Questions & Answers

### 7.1 🏫 Get Classes (with Q&A)
```
POST https://saptahikgyan.space/wb-admin/Api/app/qa/classes.php
```

**Request:** `{}` (empty)

**Response:**
```json
{
  "data": [
    {
      "id": 9,
      "name": "9",
      "grade": "9",
      "subject_count": 3,
      "question_count": 45
    }
  ]
}
```

---

### 7.2 📖 Get Subjects (with Q&A)
```
POST https://saptahikgyan.space/wb-admin/Api/app/qa/subjects.php
```

**Request:**
```json
{ "class_id": 9 }
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Bangla",
      "question_count": 25
    }
  ]
}
```

---

### 7.3 📑 Get Chapters (with Q&A)
```
POST https://saptahikgyan.space/wb-admin/Api/app/qa/chapters.php
```

**Request:**
```json
{
  "class_id": 9,
  "subject_id": 1
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Chapter 1",
      "question_count": 8
    }
  ]
}
```

---

### 7.4 🏷️ Get Question Types
```
POST https://saptahikgyan.space/wb-admin/Api/app/qa/types.php
```

**Request:** `{}` (empty)

**Response:**
```json
{
  "data": [
    { "type": "veryShort",  "label": "Very Short",  "description": "Brief one-line answers" },
    { "type": "explanatory","label": "Explanatory",  "description": "Detailed explanations" },
    { "type": "essay",      "label": "Essay-Type",  "description": "Long-form descriptive answers" }
  ]
}
```

> ⚠️ **Send these `type` values back exactly as-is** to `qa/items.php`.

---

### 7.5 ❓ Get Q&A Items
```
POST https://saptahikgyan.space/wb-admin/Api/app/qa/items.php
```

**Request:**
```json
{
  "class_id": 9,
  "subject_id": 1,
  "chapter_id": 1,
  "type": "veryShort"
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "question": "What is the main theme of 'Pother Pachali'?",
      "answer": "The main theme revolves around rural Bengali life...",
      "type": "veryShort",
      "subject_id": 1,
      "chapter_id": 1,
      "class_id": 9
    }
  ]
}
```

---

## 8. Solution Hub – Suggestions

### 8.1 🏫 Get Classes (with suggestions)
```
POST https://saptahikgyan.space/wb-admin/Api/app/suggestions/classes.php
```

**Request:** `{}` (empty)

**Response:**
```json
{
  "data": [
    {
      "id": 9,
      "name": "9",
      "grade": "9",
      "subject_count": 4,
      "suggestion_count": 8
    }
  ]
}
```

---

### 8.2 📖 Get Subjects (with suggestions)
```
POST https://saptahikgyan.space/wb-admin/Api/app/suggestions/subjects.php
```

**Request:**
```json
{ "class_id": 9 }
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Bangla",
      "suggestion_count": 4
    }
  ]
}
```

---

### 8.3 📋 Get Suggestion List
```
POST https://saptahikgyan.space/wb-admin/Api/app/suggestions/items.php
```

**Request:**
```json
{
  "class_id": 9,
  "subject_id": 1
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Bangla Grammar Tips",
      "subject_id": 1,
      "class_id": 9
    }
  ]
}
```

---

### 8.4 📄 Get Suggestion Detail
```
POST https://saptahikgyan.space/wb-admin/Api/app/suggestions/detail.php
```

**Request:**
```json
{ "id": 1 }
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "name": "Bangla Grammar Tips",
    "content": "Focus on Sandhi, Samas, and Karaka for Class 9...",
    "subject_id": 1,
    "class_id": 9
  }
}
```

---

## 9. Solution Hub – Previous Year Questions

### 9.1 📂 Get Categories
```
POST https://saptahikgyan.space/wb-admin/Api/app/pyq/categories.php
```

**Request:** `{}` (empty)

**Response:**
```json
{
  "data": [
    {
      "name": "Madhyamik",
      "subtitle": "Class 10 board exam",
      "years": [2020, 2021, 2022, 2023, 2024]
    }
  ]
}
```

---

### 9.2 📖 Get Subjects (by category + year)
```
POST https://saptahikgyan.space/wb-admin/Api/app/pyq/subjects.php
```

**Request:**
```json
{
  "category": "Madhyamik",
  "year": 2024
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Bangla",
      "question_count": 5
    }
  ]
}
```

---

### 9.3 📄 Get PYQ PDFs
```
POST https://saptahikgyan.space/wb-admin/Api/app/pyq/questions.php
```

**Request:**
```json
{
  "category": "Madhyamik",
  "year": 2024,
  "subject_id": 1
}
```

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "year": 2024,
      "pdf_file": "uploads/pyq/madhyamik_2024_bangla.pdf",
      "subject_name": "Bangla"
    }
  ]
}
```

---

## 📌 Quick Summary — All 29 Endpoints

| # | Full URL | Purpose |
|---|----------|---------|
| 1 | `https://saptahikgyan.space/wb-admin/Api/app/login.php` | 🔐 User sign in |
| 2 | `https://saptahikgyan.space/wb-admin/Api/app/signup.php` | 📝 User registration |
| 3 | `https://saptahikgyan.space/wb-admin/Api/app/fetch-profile.php` | 👤 Get profile |
| 4 | `https://saptahikgyan.space/wb-admin/Api/app/update-profile.php` | ✏️ Update profile |
| 5 | `https://saptahikgyan.space/wb-admin/Api/app/dashboard.php` | 📊 User dashboard |
| 6 | `https://saptahikgyan.space/wb-admin/Api/app/daily-test/classes.php` | 🏫 Classes with daily tests |
| 7 | `https://saptahikgyan.space/wb-admin/Api/app/daily-test/subjects.php` | 📖 Subjects with daily tests |
| 8 | `https://saptahikgyan.space/wb-admin/Api/app/daily-test/tests.php` | 📋 Available daily tests |
| 9 | `https://saptahikgyan.space/wb-admin/Api/app/daily-test/start.php` | ▶️ Start daily test |
| 10 | `https://saptahikgyan.space/wb-admin/Api/app/all-tests/classes.php` | 🏫 Classes with test sets |
| 11 | `https://saptahikgyan.space/wb-admin/Api/app/all-tests/subjects.php` | 📖 Subjects with sets |
| 12 | `https://saptahikgyan.space/wb-admin/Api/app/all-tests/chapters.php` | 📑 Chapters with sets |
| 13 | `https://saptahikgyan.space/wb-admin/Api/app/all-tests/sets.php` | 📦 Test sets list |
| 14 | `https://saptahikgyan.space/wb-admin/Api/app/all-tests/start-set.php` | ▶️ Start set test |
| 15 | `https://saptahikgyan.space/wb-admin/Api/app/submit-mocktest.php` | ✅ Submit answers |
| 16 | `https://saptahikgyan.space/wb-admin/Api/app/check-mock-answer.php` | 🔍 Check answers |
| 17 | `https://saptahikgyan.space/wb-admin/Api/app/test/history.php` | 📜 Test history |
| 18 | `https://saptahikgyan.space/wb-admin/Api/app/qa/classes.php` | 🏫 Classes with Q&A |
| 19 | `https://saptahikgyan.space/wb-admin/Api/app/qa/subjects.php` | 📖 Subjects with Q&A |
| 20 | `https://saptahikgyan.space/wb-admin/Api/app/qa/chapters.php` | 📑 Chapters with Q&A |
| 21 | `https://saptahikgyan.space/wb-admin/Api/app/qa/types.php` | 🏷️ Question types |
| 22 | `https://saptahikgyan.space/wb-admin/Api/app/qa/items.php` | ❓ Q&A items |
| 23 | `https://saptahikgyan.space/wb-admin/Api/app/suggestions/classes.php` | 🏫 Classes with suggestions |
| 24 | `https://saptahikgyan.space/wb-admin/Api/app/suggestions/subjects.php` | 📖 Subjects with suggestions |
| 25 | `https://saptahikgyan.space/wb-admin/Api/app/suggestions/items.php` | 📋 Suggestion list |
| 26 | `https://saptahikgyan.space/wb-admin/Api/app/suggestions/detail.php` | 📄 Suggestion detail |
| 27 | `https://saptahikgyan.space/wb-admin/Api/app/pyq/categories.php` | 📂 PYQ categories |
| 28 | `https://saptahikgyan.space/wb-admin/Api/app/pyq/subjects.php` | 📖 PYQ subjects |
| 29 | `https://saptahikgyan.space/wb-admin/Api/app/pyq/questions.php` | 📄 PYQ PDFs |
