-- sql/create_tables.sql

-- 로그인
CREATE TABLE LOGIN (
    USER_ID VARCHAR(20) NOT NULL PRIMARY KEY,
    PROVIDER_ID VARCHAR(255),
    PASSWORD VARCHAR(255),
    IS_ACTIVE TINYINT(1) DEFAULT TRUE,
    CREATE_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP
);

-- 공개 프로필
CREATE TABLE PUBLIC_PROFILE (
    PUBLIC_PROFILE_ID VARCHAR(30) NOT NULL PRIMARY KEY,
    FREELANCER_USER_ID VARCHAR(20) NOT NULL,
    PROFILE_IMAGE_PATH VARCHAR(255),
    NICKNAME VARCHAR(20) NOT NULL,
    MATCHING_COUNT INT DEFAULT 0,
    SERVICE_OPTION TEXT,
    AVG_RESPONSE_TIME INT,
    PRICE_UNIT VARCHAR(5),  -- 프리랜서 금액 단위 (예: "USD")
    PAYMENT_AMOUNT DECIMAL(10, 2) NOT NULL,
    SPECIALIZATION VARCHAR(255),
    AVG_RATING DECIMAL(3,1),
    FREELANCER_BADGE VARCHAR(10),
    REGISTERED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    -- 외래키 지정
    FOREIGN KEY (FREELANCER_USER_ID) REFERENCES LOGIN(USER_ID)
);



CREATE TABLE CHAT_ROOM_MASTER (
    CHAT_ROOM_ID VARCHAR(50) PRIMARY KEY,
    QUOTATION_ID VARCHAR(50) NULL,
    FREELANCER_USER_ID VARCHAR(20) NULL,
    CLIENT_USER_ID VARCHAR(20) NULL,
    START_POST_ID VARCHAR(50) NULL,
    FREELANCER_TRADE_STATUS INT NOT NULL,
    CLIENT_TRADE_STATUS INT NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
   
);

-- 결제
CREATE TABLE PAYMENT (
    CHAT_ROOM_ID VARCHAR(50) NOT NULL PRIMARY KEY,
    QUOTATION_ID VARCHAR(50) NOT NULL,
    FREELANCER_USER_ID VARCHAR(20) NOT NULL,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    USER_NAME VARCHAR(100),
    PROJECT_TITLE VARCHAR(200),
    PRICE_UNIT VARCHAR(5),
    PAYMENT_AMOUNT DECIMAL(10, 2) NOT NULL,
    PAYMENT_ST VARCHAR(50),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (CHAT_ROOM_ID) REFERENCES CHAT_ROOM_MASTER(CHAT_ROOM_ID),
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES LOGIN(USER_ID),
    FOREIGN KEY (FREELANCER_USER_ID) REFERENCES LOGIN(USER_ID)
);

-- 찜 목록
CREATE TABLE FAVORITE_LIST (
    FAVORITE_LIST_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    AUTHOR_ID VARCHAR(20) NOT NULL,
    FAVORITE_POST_ID VARCHAR(50),
    CATEGORY VARCHAR(100),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (USER_ID) REFERENCES LOGIN(USER_ID),
    FOREIGN KEY (AUTHOR_ID) REFERENCES LOGIN(USER_ID)
);

-- 회원 탈퇴 로그
CREATE TABLE MEMBER_WITHDRAWAL_LOG (
    USER_ID VARCHAR(20) PRIMARY KEY,
    REASON VARCHAR(255),
    WITHDRAWAL_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (USER_ID) REFERENCES LOGIN(USER_ID)
);

-- 본인인증
CREATE TABLE IDENTITY_VERIFICATION (
    USER_ID VARCHAR(20) PRIMARY KEY,
    VERIFICATION_STATUS TINYINT(1) NOT NULL,
    PHONE_NUMBER VARCHAR(20) NOT NULL,
    VERIFICATION_CODE CHAR(6) NOT NULL,
    EXPIRATION_TIME TIMESTAMP NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (USER_ID) REFERENCES LOGIN(USER_ID)
);

-- 프로젝트 글 목록
CREATE TABLE PROJECT_LIST (
    PROJECT_ID VARCHAR(50) PRIMARY KEY,
    PUBLIC_PROFILE_ID VARCHAR(30) NOT NULL,
    FREELANCER_USER_ID VARCHAR(20) NOT NULL,
    PROJECT_TITLE VARCHAR(200) NOT NULL,
    FIELD VARCHAR(100),
    PROJECT_PAYMENT_AMOUNT INT NOT NULL,
    MAIN_IMAGE_PATH VARCHAR(255),
    SERVICE_OPTIONS TEXT,
    AVG_RESPONSE_TIME INT,
    FREELANCER_BADGE VARCHAR(10),
    AVG_RATING DECIMAL(3, 1),
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (PUBLIC_PROFILE_ID) REFERENCES PUBLIC_PROFILE(PUBLIC_PROFILE_ID),
    FOREIGN KEY (FREELANCER_USER_ID) REFERENCES LOGIN(USER_ID)
);

-- 클라이언트 글 목록
CREATE TABLE CLIENT_POST_LIST (
    CLIENT_POST_ID VARCHAR(50) PRIMARY KEY,
    CLIENT_USER_ID VARCHAR(20) NOT NULL,
    CLIENT_TITLE VARCHAR(200),
    CLIENT_PAYMENT_AMOUNT INT,
    DESIRED_DEADLINE DATE,
    FINAL_DEADLINE DATE,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (CLIENT_USER_ID) REFERENCES LOGIN(USER_ID)
);

-- 사용자 동의
CREATE TABLE USER_CONSENT (
    USER_ID VARCHAR(20) NOT NULL PRIMARY KEY,  
    PERSONAL_INFO_CONSENT TINYINT(1) NOT NULL,  
    TERMS_OF_SERVICE_CONSENT TINYINT(1) NOT NULL,  
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
);

-- FAQ
CREATE TABLE FAQ (
    FAQ_ID VARCHAR(20) NOT NULL PRIMARY KEY,  
    CATEGORY_FAQ VARCHAR(255) NOT NULL,  
    QUESTION TEXT NOT NULL,  
    ANSWER TEXT NOT NULL,  
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  
);

-- 작성글
CREATE TABLE POSTMANAGEMENT (
    POST_ID VARCHAR(50) PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,  
    CATEGORY VARCHAR(100) NOT NULL, 
    PROJECT_TITLE VARCHAR(255) NOT NULL, 
    CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP, 
    UPDATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 

    -- 외래키 지정
    FOREIGN KEY (USER_ID) REFERENCES LOGIN(USER_ID)
);

-- 이메일 알림
CREATE TABLE EMAIL_NOTIFICATION (
    SEQUENCE INT AUTO_INCREMENT PRIMARY KEY,
    USER_ID VARCHAR(20) NOT NULL,
    EMAIL VARCHAR(50) NOT NULL,
    MESSAGE_TYPE INT NOT NULL,
    CREATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- 외래키 지정
    FOREIGN KEY (USER_ID) REFERENCES LOGIN(USER_ID)
);
