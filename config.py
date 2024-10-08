import os
from dotenv import load_dotenv
from mongoengine import connect

# .env 파일 로드
load_dotenv()

class Config:
    # MySQL 데이터베이스 설정
    SQLALCHEMY_DATABASE_URI = os.getenv('MYSQL_DATABASE_URI')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    #DEBUG = True  # 디버그 모드 활성화

    # MongoDB 설정
    MONGO_URI = os.getenv('MONGO_URI')
    connect(host=MONGO_URI, alias='default')

    # Flask Secret Key (세션 관리, CSRF 방지 등)
    SECRET_KEY = os.getenv('SECRET_KEY')

    # Flask-Mail 설정
    MAIL_SERVER = 'smtp.naver.com'  # Naver SMTP 서버 설정
    MAIL_PORT = 587
    MAIL_USE_TLS = True
    MAIL_USERNAME = os.getenv('MAIL_USERNAME')  # 환경 변수에서 네이버 이메일 가져오기
    MAIL_PASSWORD = os.getenv('MAIL_PASSWORD')  # 환경 변수에서 네이버 이메일 비밀번호 가져오기
    MAIL_DEFAULT_SENDER = os.getenv('MAIL_USERNAME')  # 기본 발신자 설정

    #twilio 설정
    TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
    TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
    TWILIO_PHONE_NUMBER = os.getenv("TWILIO_PHONE_NUMBER")

# 개발 환경을 위한 추가 설정
class DevelopmentConfig(Config):
    DEBUG = True
    SQLALCHEMY_ECHO = True  # SQLAlchemy가 실행하는 SQL 쿼리를 출력

# 프로덕션 환경을 위한 추가 설정
# class ProductionConfig(Config):
#     DEBUG = False

# 현재 환경 설정을 선택
config = {
    'development': DevelopmentConfig,
    # 'production': ProductionConfig,
}
