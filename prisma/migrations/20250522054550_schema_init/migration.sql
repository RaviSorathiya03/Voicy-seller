-- CreateEnum
CREATE TYPE "WebinarStatusEnum" AS ENUM ('SCHEDULED', 'WAITING_ROOM', 'LIVE', 'ENDED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "CtaTypeEnum" AS ENUM ('BUY_NOW', 'BOOK_A_CALL');

-- CreateEnum
CREATE TYPE "CallStatusEnum" AS ENUM ('PENDING', 'INPROGRESS', 'COMPLETED');

-- CreateEnum
CREATE TYPE "AttendedTypeEnum" AS ENUM ('REGISTERED', 'ATTENDED', 'ADDED_TO_CART', 'FOLLOW_UP', 'BREAKOUT_ROOM', 'CONVERTED');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "clerkId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "profileImg" TEXT NOT NULL,
    "lastLoginAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "subscription" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Webinar" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3),
    "duration" INTEGER NOT NULL DEFAULT 0,
    "WebinarStatus" "WebinarStatusEnum" NOT NULL DEFAULT 'SCHEDULED',
    "presenterId" TEXT NOT NULL,
    "tags" TEXT[],
    "ctLabel" TEXT,
    "ctaType" "CtaTypeEnum" NOT NULL,
    "ctaUrl" TEXT,
    "couponCode" TEXT,
    "couponExpiry" TIMESTAMP(3),
    "lockChat" BOOLEAN NOT NULL DEFAULT false,
    "aiAgentId" TEXT,
    "priceId" TEXT,
    "recordingUrl" TEXT,
    "thumbnail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "attendeeId" TEXT,

    CONSTRAINT "Webinar_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attendee" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "callStatus" "CallStatusEnum" NOT NULL DEFAULT 'PENDING',

    CONSTRAINT "Attendee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attendance" (
    "id" TEXT NOT NULL,
    "webinarId" TEXT NOT NULL,
    "joinedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "leftAt" TIMESTAMP(3),
    "attendedType" "AttendedTypeEnum" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAtn" TIMESTAMP(3) NOT NULL,
    "attendeeId" TEXT NOT NULL,
    "userId" TEXT,

    CONSTRAINT "Attendance_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_clerkId_key" ON "User"("clerkId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_email_idx" ON "User"("email");

-- CreateIndex
CREATE INDEX "User_clerkId_idx" ON "User"("clerkId");

-- CreateIndex
CREATE INDEX "Webinar_presenterId_idx" ON "Webinar"("presenterId");

-- CreateIndex
CREATE INDEX "Webinar_aiAgentId_idx" ON "Webinar"("aiAgentId");

-- CreateIndex
CREATE INDEX "Webinar_startTime_idx" ON "Webinar"("startTime");

-- CreateIndex
CREATE UNIQUE INDEX "Attendee_email_key" ON "Attendee"("email");

-- CreateIndex
CREATE INDEX "Attendance_webinarId_idx" ON "Attendance"("webinarId");

-- CreateIndex
CREATE INDEX "Attendance_attendedType_idx" ON "Attendance"("attendedType");

-- CreateIndex
CREATE UNIQUE INDEX "Attendance_attendeeId_webinarId_key" ON "Attendance"("attendeeId", "webinarId");

-- AddForeignKey
ALTER TABLE "Webinar" ADD CONSTRAINT "Webinar_presenterId_fkey" FOREIGN KEY ("presenterId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Webinar" ADD CONSTRAINT "Webinar_attendeeId_fkey" FOREIGN KEY ("attendeeId") REFERENCES "Attendee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attendance" ADD CONSTRAINT "Attendance_attendeeId_fkey" FOREIGN KEY ("attendeeId") REFERENCES "Attendee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Attendance" ADD CONSTRAINT "Attendance_webinarId_fkey" FOREIGN KEY ("webinarId") REFERENCES "Webinar"("id") ON DELETE CASCADE ON UPDATE CASCADE;
