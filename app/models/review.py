from app import db
from datetime import datetime

class Review(db.Model):
    __tablename__ = 'REVIEW'
    
    sequence = db.Column(db.Integer, primary_key=True, autoincrement=True)
    public_profile_id = db.Column(db.String(50), db.ForeignKey('PUBLIC_PROFILE.public_profile_id', ondelete='CASCADE'), nullable=False)
    client_user_id = db.Column(db.String(20), db.ForeignKey('USER_INFORMATION.user_id', ondelete='CASCADE'), nullable=False)
    review_title = db.Column(db.String(100), nullable=False)
    review_text = db.Column(db.Text)
    rating = db.Column(db.Integer, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    public_profile = db.relationship('PublicProfile', backref=db.backref('reviews', lazy=True, cascade="all, delete-orphan"))
    client_user = db.relationship('UserInformation', backref=db.backref('client_reviews', lazy=True, cascade="all, delete-orphan"))
