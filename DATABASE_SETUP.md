# Database Setup Guide

This guide explains how to set up the database for persistent face data storage.

## Database Options

### 1. PostgreSQL (Recommended for Production)

#### Option A: Vercel Postgres (Easiest)
1. Go to your Vercel dashboard
2. Select your project
3. Go to Storage → Create Database → Postgres
4. Copy the connection string
5. Add it to your environment variables as `DATABASE_URL`

#### Option B: Railway
1. Go to [Railway.app](https://railway.app)
2. Create a new project
3. Add PostgreSQL service
4. Copy the connection string
5. Add it to your environment variables as `DATABASE_URL`

#### Option C: Supabase
1. Go to [Supabase.com](https://supabase.com)
2. Create a new project
3. Go to Settings → Database
4. Copy the connection string
5. Add it to your environment variables as `DATABASE_URL`

### 2. Local Development

For local development, you can use Docker:

```bash
# Run PostgreSQL with Docker
docker run --name face-recognition-db \
  -e POSTGRES_USER=faceuser \
  -e POSTGRES_PASSWORD=facepass \
  -e POSTGRES_DB=face_recognition \
  -p 5432:5432 \
  -d postgres:13

# Connection string for local development
DATABASE_URL=postgresql://faceuser:facepass@localhost:5432/face_recognition
```

## Environment Variables

Create a `.env.local` file in your project root:

```env
# Database
DATABASE_URL=your_database_connection_string_here

# API Configuration
REACT_APP_API_URL=/api
REACT_APP_FACE_API_MODELS_URL=https://justadudewhohacks.github.io/face-api.js/models

# Node Environment
NODE_ENV=production
```

## Vercel Deployment

1. Install dependencies:
```bash
npm install
```

2. Set up environment variables in Vercel:
   - Go to your Vercel project dashboard
   - Navigate to Settings → Environment Variables
   - Add `DATABASE_URL` with your database connection string
   - Add `NODE_ENV` set to `production`

3. Deploy:
```bash
vercel --prod
```

## Database Schema

The application automatically creates these tables:

### `registered_faces`
- `id` (SERIAL PRIMARY KEY)
- `label` (VARCHAR(255) NOT NULL UNIQUE) - Person's name
- `descriptors` (JSONB NOT NULL) - Face descriptor data
- `created_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

### `attendance_log`
- `id` (SERIAL PRIMARY KEY)
- `person_name` (VARCHAR(255) NOT NULL)
- `date` (DATE NOT NULL)
- `time` (TIME NOT NULL)
- `timestamp` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
- UNIQUE constraint on (`person_name`, `date`)

## API Endpoints

The application provides these API endpoints:

### Face Management
- `GET /api/faces` - Get all registered faces
- `POST /api/faces` - Register a new face
- `DELETE /api/faces/:label` - Delete a specific face
- `DELETE /api/faces` - Clear all faces

### Attendance Management
- `GET /api/attendance` - Get attendance log
- `POST /api/attendance` - Mark attendance
- `DELETE /api/attendance` - Clear attendance log

### Health Check
- `GET /api/health` - API health check

## Troubleshooting

### Database Connection Issues
1. Check your `DATABASE_URL` format
2. Ensure your database is accessible from Vercel
3. Verify SSL settings (most cloud databases require SSL)

### Migration Issues
- The app automatically creates tables on startup
- If you need to reset, drop the tables and restart the application

### Performance
- Face descriptors are stored as JSONB for efficient querying
- Consider adding indexes for better performance with large datasets:

```sql
CREATE INDEX idx_faces_label ON registered_faces(label);
CREATE INDEX idx_attendance_person_date ON attendance_log(person_name, date);
```

## Security Notes

1. Always use environment variables for database credentials
2. Enable SSL for database connections in production
3. Consider implementing rate limiting for API endpoints
4. Regularly backup your database

## Data Migration

If you have existing face data, you can migrate it using the API endpoints or direct database insertion.