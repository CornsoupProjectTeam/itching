from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class PreferredWorkStyleMapping(db.Model):
    __tablename__ = 'PREFERRED_WORK_STYLE_MAPPING'
    
    public_profile_id = db.Column(db.String(50), db.ForeignKey('PUBLIC_PROFILE.public_profile_id'), primary_key=True)
    preferred_code = db.Column(db.String(20), db.ForeignKey('FIELD_KEYWORDS.field_code'))
    
    public_profile = db.relationship('PublicProfile', backref=db.backref('preferred_work_styles', lazy=True))
    field_keywords = db.relationship('FieldKeywords', backref=db.backref('preferred_work_style_mappings', lazy=True))