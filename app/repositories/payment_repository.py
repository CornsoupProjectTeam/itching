#payment_repository.py

from app.models.payment import Payment
from app.models.login import Login
from app import db

class PaymentRepository:

    @staticmethod
    def verify_card_name(user_name):
        payment = Payment.query.filter_by(user_name=user_name).first()
        return payment is not None
    
    @staticmethod
    def insert_user_name(chat_room_id, user_name):
        payment = Payment.query.filter_by(chat_room_id=chat_room_id).first()
        if payment:
            payment.user_name = user_name
            db.session.commit()

    @staticmethod
    def find_by_user_name(user_name):
        return Payment.query.filter_by(user_name=user_name).first()

    @staticmethod
    def find_by_client_user_id(client_user_id):
        return Payment.query.filter_by(client_user_id=client_user_id).first()