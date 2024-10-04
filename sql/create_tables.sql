CREATE DATABASE itching;

USE itching;

-- LOGIN
CREATE TABLE LOGIN (
    USER_ID VARCHAR(20) PRIMARY KEY,
    PROVIDER_ID VARCHAR(255),
    PASSWORD VARCHAR(255),
    IS_ACTIVE TINYINT DEFAULT 0,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- USER_INFORMATION
CREATE TABLE USER_INFORMATION (
    USER_ID VARCHAR(20) PRIMARY KEY,
    EMAIL VARCHAR(50) NOT NULL UNIQUE,
    PROFILE_PICTURE_PATH VARCHAR(255),
    NICKNAME VARCHAR(20) NOT NULL,
    BUSINESS_AREA VARCHAR(100),
    INQUIRY_ST TINYINT DEFAULT 0,
    FREELANCER_REGISTRATION_ST TINYINT DEFAULT 0,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES LOGIN(USER_ID) ON DELETE CASCADE
);

-- FIELD_KEYWORDS
CREATE TABLE FIELD_KEYWORDS (
    FIELD_CODE VARCHAR(20) PRIMARY KEY,
    FIELD_TYPE VARCHAR(50) NOT NULL,
    FIELD_NAME VARCHAR(100) NOT NULL UNIQUE
);

-- SKILL_KEYWORDS
CREATE TABLE SKILL_KEYWORDS (
    SKILL_CODE VARCHAR(20) PRIMARY KEY,
    SKILL_NAME VARCHAR(100) NOT NULL UNIQUE
);

-- PREFERRED_KEYWORDS
CREATE TABLE PREFERRED_KEYWORDS (
    PREFERRED_CODE VARCHAR(20) PRIMARY KEY,
    PREFERRED_TYPE VARCHAR(50) NOT NULL,
    PREFERRED_NAME VARCHAR(100) NOT NULL
);

-- PUBLIC_PROFILE
CREATE TABLE PUBLIC_PROFILE (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    NICKNAME VARCHAR(20) NOT NULL,
    PROFILE_IMAGE_PATH VARCHAR(255),
    FREELANCER_INTRO_ONE_LINER VARCHAR(100),
    FREELANCER_INTRO TEXT,
    PROJECT_DURATION INT,
    FREELANCER_BADGE ENUM('Gold', 'Silver', 'Bronze'),
    MATCH_COUNT INT,
    AVERAGE_RESPONSE_TIME INT,
    FREELANCER_REGISTRATION_DATE DATETIME,
    PUBLIC_PROFILE_REGISTRATION_ST TINYINT DEFAULT 1,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- USER_CONSENT
CREATE TABLE USER_CONSENT (
    USER_ID VARCHAR(20) NOT NULL PRIMARY KEY,
    PERSONAL_INFO_CONSENT TINYINT NOT NULL DEFAULT 0,
    TERMS_OF_SERVICE_CONSENT TINYINT NOT NULL DEFAULT 0,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- EMAIL_NOTIFICATION
CREATE TABLE EMAIL_NOTIFICATION (
    SEQUENCE INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    EMAIL VARCHAR(50) NOT NULL,
    MESSAGE_TYPE INT NOT NULL,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- FREELANCER_PRICE_RANGE
CREATE TABLE FREELANCER_PRICE_RANGE (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    MIN_PRICE DECIMAL(10, 2) NOT NULL,
    MAX_PRICE DECIMAL(10, 2) NOT NULL,
    PRICE_UNIT ENUM('KRW', 'USD') DEFAULT 'KRW',
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- SERVICE_OPTIONS
CREATE TABLE SERVICE_OPTIONS (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    WEEKEND_CONSULTATION TINYINT DEFAULT 0,
    WEEKEND_WORK TINYINT DEFAULT 0,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- FREELANCER_EXPERTISE_FIELD_MAPPING
CREATE TABLE FREELANCER_EXPERTISE_FIELD_MAPPING (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    FIELD_CODE VARCHAR(20),
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE,
    FOREIGN KEY (FIELD_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);

-- FREELANCER_SKILLS_MAPPING
CREATE TABLE FREELANCER_SKILLS_MAPPING (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    SKILL_CODE VARCHAR(20),
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE,
    FOREIGN KEY (SKILL_CODE) REFERENCES SKILL_KEYWORDS(SKILL_CODE) ON DELETE CASCADE
);

-- CAREER_MAPPING
CREATE TABLE CAREER_MAPPING (
    CAREER_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(50),
    COMPANY VARCHAR(100) NOT NULL,
    ROLE VARCHAR(50) NOT NULL,
    DURATION INT NOT NULL,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- EDUCATION_MAPPING
CREATE TABLE EDUCATION_MAPPING (
    EDUCATION_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(50) NOT NULL,
    SCHOOL VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- PREFERRED_WORK_STYLE_MAPPING
CREATE TABLE PREFERRED_WORK_STYLE_MAPPING (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    PREFERRED_CODE VARCHAR(20),
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE,
    FOREIGN KEY (PREFERRED_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);

-- REVIEW_SUMMARY
CREATE TABLE REVIEW_SUMMARY (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    TOTAL_REVIEWS INT DEFAULT 0,
    AVERAGE_RATING DECIMAL(3, 2) DEFAULT 0.00,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- REVIEW
CREATE TABLE REVIEW (
    REVIEW_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(50) NOT NULL,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    REVIEW_TITLE VARCHAR(100) NOT NULL,
    REVIEW_TEXT TEXT,
    RATING TINYINT CHECK (RATING >= 1 AND RATING <= 5),
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE,
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- PROJECT_INFO
CREATE TABLE PROJECT_INFO (
    PROJECT_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(50) NOT NULL,
    FIELD_CODE VARCHAR(20) NOT NULL,
    PROJECT_TITLE VARCHAR(200) NOT NULL,
    PROJECT_PAYMENT_AMOUNT INT NOT NULL,
    DESIGN_DRAFT_COUNT INT NOT NULL,
    PRODUCTION_TIME INT NOT NULL,
    COMMERCIAL_USER_ALLOWED TINYINT DEFAULT 0,
    HIGH_RESOLUTION_FILE_AVAILABLE TINYINT DEFAULT 0,
    DELIVERY_ROUTES TEXT,
    ADDITIONAL_NOTES TEXT,
    CANCELLATION_AND_REFUND_POLICY TEXT,
    PRODUCT_INFO_DISCLOSURE TEXT,
    ADDITIONAL_INFO TEXT,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE,
    FOREIGN KEY (FIELD_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);

-- PROJECT_LIST
CREATE TABLE PROJECT_LIST (
    PROJECT_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(50) NOT NULL,
    FIELD_CODE VARCHAR(20),
    PROJECT_TITLE VARCHAR(200) NOT NULL,
    PROJECT_PAYMENT_AMOUNT INT NOT NULL,
    AVG_RESPONSE_TIME INT,
    FREELANCER_BADGE ENUM('Gold', 'Silver', 'Bronze'),
    AVERAGE_RATING DECIMAL(3, 2) DEFAULT 0.00,
    WEEKEND_CONSULTATION TINYINT DEFAULT 0,
    WEEKEND_WORK TINYINT DEFAULT 0,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT_INFO(PROJECT_ID) ON DELETE CASCADE,
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE,
    FOREIGN KEY (FIELD_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);

-- PROJECT_IMAGE_MAPPING
CREATE TABLE PROJECT_IMAGE_MAPPING (
    PROJECT_ID VARCHAR(50) PRIMARY KEY,
    IMAGE_PATH VARCHAR(255),
    
    FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT_INFO(PROJECT_ID) ON DELETE CASCADE
);

-- PUBLIC_PROFILE_LIST
CREATE TABLE PUBLIC_PROFILE_LIST (
    PUBLIC_PROFILE_ID VARCHAR(50) PRIMARY KEY,
    NICKNAME VARCHAR(20) NOT NULL,
    PROFILE_IMAGE_PATH VARCHAR(255),
    FREELANCER_BADGE ENUM('Gold', 'Silver', 'Bronze'),
    MATCH_COUNT INT DEFAULT 0,
    AVERAGE_RESPONSE_TIME INT,
    FREELANCER_REGISTRATION_DATE DATETIME,
    AVERAGE_RATING DECIMAL(3, 2) DEFAULT 0.00,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- CLIENT_POST
CREATE TABLE CLIENT_POST (
    CLIENT_POST_ID VARCHAR(50) PRIMARY KEY,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    FIELD_CODE VARCHAR(20) NOT NULL,
    CLIENT_TITLE VARCHAR(200) NOT NULL,
    CLIENT_PAYMENT_AMOUNT INT NOT NULL,
    COMPLETION_DEADLINE DATE NOT NULL,
    POSTING_DEADLINE DATE NOT NULL,
    REQUIREMENTS TEXT NOT NULL,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (FIELD_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);

-- CLIENT_POST_LIST
CREATE TABLE CLIENT_POST_LIST (
    CLIENT_POST_ID VARCHAR(50) PRIMARY KEY,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    FIELD_CODE VARCHAR(20) NOT NULL,
    CLIENT_TITLE VARCHAR(200),
    CLIENT_PAYMENT_AMOUNT INT,
    DESIRED_DEADLINE DATE,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (CLIENT_POST_ID) REFERENCES CLIENT_POST(CLIENT_POST_ID) ON DELETE CASCADE,
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (FIELD_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);

-- CLIENT_POST_REFERENCE_IMAGE_MAPPING
CREATE TABLE CLIENT_POST_REFERENCE_IMAGE_MAPPING (
    CLIENT_POST_ID VARCHAR(50) PRIMARY KEY,
    REFERENCE_IMAGE_PATH VARCHAR(255),
    
    FOREIGN KEY (CLIENT_POST_ID) REFERENCES CLIENT_POST(CLIENT_POST_ID) ON DELETE CASCADE
);

-- POST_MANAGEMENT
CREATE TABLE POST_MANAGEMENT (
    POST_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    CATEGORY ENUM('Client', 'Project') NOT NULL,
    REFERENCE_POST_ID VARCHAR(50) NOT NULL,
    PROJECT_TITLE VARCHAR(200) NOT NULL,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- RECOMMENDATION
CREATE TABLE RECOMMENDATION (
    RECOMMENDATION_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    PUBLIC_PROFILE_ID VARCHAR(50) NOT NULL,
    MATCH_SCORE INT NOT NULL CHECK (MATCH_SCORE >= 0 AND MATCH_SCORE <= 100),
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- CHAT_ROOM_MASTER
CREATE TABLE CHAT_ROOM_MASTER (
    CHAT_ROOM_ID VARCHAR(50),
    USER_ID VARCHAR(20) NOT NULL,
    USER_TYPE ENUM('Client', 'Freelancer'),
    START_POST_ID VARCHAR(50),
    IS_DELETED TINYINT DEFAULT 0,
    IS_BLOCKED TINYINT DEFAULT 0,
    IS_NEW_NOTIFICATION TINYINT DEFAULT 0,
    TRADE_ST ENUM('In progress', 'Completed'),
    PIN_ST TINYINT DEFAULT 0,
    SUPPORT_LANGUAGE VARCHAR(50),
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (CHAT_ROOM_ID, USER_ID),
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- CHAT_ROOM_QUOTATION
CREATE TABLE CHAT_ROOM_QUOTATION (
    QUOTATION_ID VARCHAR(50) PRIMARY KEY,
    CHAT_ROOM_ID VARCHAR(50) NOT NULL,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    FREELANCER_USER_ID VARCHAR(20) NOT NULL,
    QUOTATION_ST ENUM('Submitted', 'Accepted'),
    QUOTATION DECIMAL(10, 2),
    NUMBER_OF_DRAFTS INT,
    MIDTERM_CHECK DATE,
    FINAL_DEADLINE DATE NOT NULL,
    REVISION_COUNT INT,
    ADDITIONAL_REVISION_PURCHASE_AVAILABLE TINYINT,
    COMMERCIAL_USE_ALLOWED TINYINT,
    HIGH_RESOLUTION_FILE_AVAILABLE TINYINT,
    DELIVERY_ROUTE TEXT,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (CHAT_ROOM_ID) REFERENCES CHAT_ROOM_MASTER(CHAT_ROOM_ID) ON DELETE CASCADE,
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (FREELANCER_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- PAYMENT
CREATE TABLE PAYMENT (
    CHAT_ROOM_ID VARCHAR(50) PRIMARY KEY,
    QUOTATION_ID VARCHAR(50) NOT NULL,
    FREELANCER_USER_ID VARCHAR(50) NOT NULL,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    USER_NAME VARCHAR(100),
    PRICE_UNIT ENUM('KRW', 'USD') DEFAULT 'KRW',
    PAYMENT_AMOUNT DECIMAL(10, 2) NOT NULL,
    PAYMENT_ST ENUM('Pending', 'Success', 'Fail') DEFAULT 'Pending',
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (CHAT_ROOM_ID) REFERENCES CHAT_ROOM_MASTER(CHAT_ROOM_ID) ON DELETE CASCADE,
    FOREIGN KEY (FREELANCER_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (QUOTATION_ID) REFERENCES CHAT_ROOM_QUOTATION(QUOTATION_ID) ON DELETE CASCADE
);

-- PRETEST_SCANNER
CREATE TABLE PRETEST_SCANNER (
    PRETEST_SCANNER_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- PRETEST_CONDITION
CREATE TABLE PRETEST_CONDITION (
    VERSION_CODE VARCHAR(20),
    SEQUENCE INT,
    REQUIREMENT TEXT,
    
    PRIMARY KEY (VERSION_CODE, SEQUENCE)
);

-- PRETEST_SCANNER_REQUIREMENT
CREATE TABLE PRETEST_SCANNER_REQUIREMENT (
    SCANNER_REQUIREMENT_ID VARCHAR(50) PRIMARY KEY,
    PRETEST_SCANNER_ID VARCHAR(50),
    VERSION_CODE VARCHAR(20),
    SEQUENCE INT,
    SCORE DECIMAL(10, 2),
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (PRETEST_SCANNER_ID) REFERENCES PRETEST_SCANNER(PRETEST_SCANNER_ID) ON DELETE CASCADE,
    FOREIGN KEY (VERSION_CODE, SEQUENCE) REFERENCES PRETEST_CONDITION(VERSION_CODE, SEQUENCE) ON DELETE CASCADE
);

-- CHAT_ROOM_SCANNER
CREATE TABLE CHAT_ROOM_SCANNER (
    CHAT_ROOM_SCANNER_ID VARCHAR(50) PRIMARY KEY,
    QUOTATION_ID VARCHAR(50),
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (QUOTATION_ID) REFERENCES CHAT_ROOM_QUOTATION(QUOTATION_ID) ON DELETE CASCADE
);

-- CHAT_ROOM_SCANNER_REQUIREMENT
CREATE TABLE CHAT_ROOM_SCANNER_REQUIREMENT (
    REQUIREMENT_ID VARCHAR(50) PRIMARY KEY,
    CHAT_ROOM_SCANNER_ID VARCHAR(50),
    SEQUENCE INT,
    REQUIREMENT TEXT,
    SCORE DECIMAL(10, 2),
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (CHAT_ROOM_SCANNER_ID) REFERENCES CHAT_ROOM_SCANNER(CHAT_ROOM_SCANNER_ID) ON DELETE CASCADE
);

-- FAVORITE_LIST
CREATE TABLE FAVORITE_LIST (
    FAVORITE_LIST_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    AUTHOR_ID VARCHAR(20) NOT NULL,
    FAVORITE_POST_ID VARCHAR(50),
    CATEGORY ENUM('Project', 'Public Profile', 'Client'),
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (AUTHOR_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- IDENTITY_VERIFICATION
CREATE TABLE IDENTITY_VERIFICATION (
    USER_ID VARCHAR(20) PRIMARY KEY,
    VERIFICATION_ST TINYINT NOT NULL DEFAULT 0,
    PHONE_NUMBER VARCHAR(20) NOT NULL,
    VERIFICATION_CODE CHAR(6) NOT NULL,
    EXPIRATION_TIME DATETIME NOT NULL,
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE
);

-- ACCOUNT_INFO
CREATE TABLE ACCOUNT_INFO (
    ACCOUNT_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(50) NOT NULL,
    BANK_NAME VARCHAR(50) NOT NULL,
    ACCOUNT_NUMBER VARCHAR(255) NOT NULL,
    ACCOUNT_HOLDER VARCHAR(50) NOT NULL,
    ACCOUNT_TYPE ENUM('Personal', 'Corporation') NOT NULL,
    
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID) ON DELETE CASCADE
);

-- PREFERRED_FREELANCER_MAPPING
CREATE TABLE PREFERRED_FREELANCER_MAPPING (
    USER_ID VARCHAR(20) PRIMARY KEY,
    PREFERRED_CODE VARCHAR(20),
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (PREFERRED_CODE) REFERENCES PREFERRED_KEYWORDS(PREFERRED_CODE) ON DELETE CASCADE
);

-- CLIENT_PREFERRED_FIELD_MAPPING
CREATE TABLE CLIENT_PREFERRED_FIELD_MAPPING (
    USER_ID VARCHAR(20) PRIMARY KEY,
    FIELD_CODE VARCHAR(20),
    
    FOREIGN KEY (USER_ID) REFERENCES USER_INFORMATION(USER_ID) ON DELETE CASCADE,
    FOREIGN KEY (FIELD_CODE) REFERENCES FIELD_KEYWORDS(FIELD_CODE) ON DELETE CASCADE
);