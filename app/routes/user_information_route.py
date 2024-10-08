from flask import Blueprint, request, jsonify, g
from app.services.user_information_service import UserInformationService
from app.repositories.user_information_repository import UserInformationRepository
from app.services.login_service import LoginService

user_information_bp = Blueprint('user_information', __name__, url_prefix='/profile/user_information')

@user_information_bp.before_request
def before_request():
    g.user_information_repository = UserInformationRepository()
    g.user_information_service = UserInformationService(g.user_information_repository, request.view_args.get('user_id'))

# GET /profile/user_information/{user_id}
@user_information_bp.route('/<user_id>', methods=['GET'])
def get_user_information(user_id):
    # 사용자 정보 조회
    user_info = g.user_information_service.get_user_information()

    if user_info:
        return jsonify(user_info), 200
    else:
        return jsonify({'success': False, 'message': '사용자 정보를 찾을 수 없습니다.'}), 404

# GET /profile/user_information/{user_id}/freelancer-registration-state
@user_information_bp.route('/<user_id>/freelancer-registration-state', methods=['GET'])
def check_freelancer_registration_state(user_id):
    freelancer_registration_state = g.user_information_service.confirm_freelancer_registration(user_id)

    if freelancer_registration_state:
        return jsonify({'freelancer_registration_state': freelancer_registration_state}), 200
    else:
        return jsonify({'success': False, 'message': '프리랜서 등록여부를 확인할 수 없습니다.'}), 404

# POST 또는 DELETE /profile/user_information/{user_id}/profile-picture
@user_information_bp.route('/<user_id>/profile-picture', methods=['POST', 'DELETE'])
def update_profile_picture(user_id):
    # 프로필 사진 등록/업데이트
    if request.method == 'POST':        
        file = request.files.get('file')

        # 파일이 없으면 오류 반환
        if not file:
            return jsonify({"success": False, "message": "파일이 제공되지 않았습니다."}), 400

        # 프로필 사진 변경 처리
        result = g.user_information_service.change_profile_picture(user_id, file)

        # 결과 반환
        if result['success']:
            return jsonify(result), 200
        else:
            return jsonify(result), 400

    # 프로필 사진 삭제
    elif request.method == 'DELETE':
        # 파일을 None으로 설정하여 삭제 로직 수행
        result = g.user_information_service.change_profile_picture(user_id, None)

        # 결과 반환
        if result['success']:
            return jsonify(result), 200
        else:
            return jsonify(result), 400
        
# GET /profile/user_information/{user_id}/nickname-check
@user_information_bp.route('/<user_id>/nickname-check', methods=['GET'])
def check_nickname(user_id):
    nickname = request.args.get('nickname')

    # 닉네임 파라미터가 없을 경우
    if not nickname:
        return jsonify({"success": False, "message": "닉네임을 입력해주세요."}), 400
    
    # 닉네임 중복 검사
    result = g.user_information_service.check_nickname_availability(nickname)

    # 결과 반환
    return jsonify(result), 200 if result['success'] else 400

# PUT /profile/user_information/{user_id}/nickname
@user_information_bp.route('/<user_id>/nickname', methods=['PUT'])
def update_nickname(user_id):
    data = request.json
    new_nickname = data.get('new_nickname')

    # 닉네임이 없을 경우
    if not new_nickname:
        return jsonify({"success": False, "message": "새로운 닉네임을 입력해주세요."}), 400

    # 닉네임 변경 처리
    result = g.user_information_service.change_nickname(user_id, new_nickname)

    # 결과 반환
    return jsonify(result), 200 if result['success'] else 400

# PUT /profile/user_information/{user_id}/business-area
@user_information_bp.route('/<user_id>/business-area', methods=['PUT'])
def update_business_area(user_id):
    data = request.json
    new_business_area = data.get('new_business_area')

    # 새로운 비즈니스 영역 값이 없는 경우
    if not new_business_area:
        return jsonify({"success": False, "message": "새로운 비즈니스 영역을 입력해주세요."}), 400

    # 비즈니스 영역 변경 처리
    result = g.user_information_service.change_business_area(user_id, new_business_area)

    # 결과 반환
    return jsonify(result), 200 if result['success'] else 400

# PUT /profile/user_information/{user_id}/preferred-fields
@user_information_bp.route('/<user_id>/preferred-fields', methods=['PUT'])
def update_preferred_fields(user_id):
    data = request.json
    field_codes = data.get('field_codes', [])

    if not field_codes:
        return jsonify({"success": False, "message": "선호 분야 코드를 입력해주세요."}), 400

    # 선호 분야 수정 처리
    result = g.user_information_service.change_preferred_field(field_codes)
    
    return jsonify(result), 200 if result['success'] else 400

# DELETE /profile/user_information/{user_id}/preferred-fields
@user_information_bp.route('/<user_id>/preferred-fields', methods=['DELETE'])
def delete_preferred_fields(user_id):
    data = request.json
    field_codes = data.get('field_codes', [])

    if not field_codes:
        return jsonify({"success": False, "message": "삭제할 선호 분야 코드를 입력해주세요."}), 400

    # 선호 분야 삭제 처리
    result = g.user_information_service.delete_preferred_field(field_codes)
    
    return jsonify(result), 200 if result['success'] else 400

# PUT /profile/user_information/{user_id}/preferred-freelancer
@user_information_bp.route('/<user_id>/preferred-freelancer', methods=['PUT'])
def update_preferred_freelancer(user_id):
    data = request.json
    preferred_freelancer_codes = data.get('preferred_freelancer_codes', [])

    if not preferred_freelancer_codes:
        return jsonify({"success": False, "message": "선호하는 프리랜서 코드를 입력해주세요."}), 400

    # 선호하는 프리랜서 수정 처리
    result = g.user_information_service.change_preferred_freelancer(preferred_freelancer_codes)
    
    return jsonify(result), 200 if result['success'] else 400

# DELETE /profile/user_information/{user_id}/preferred-freelancer
@user_information_bp.route('/<user_id>/preferred-freelancer', methods=['DELETE'])
def delete_preferred_freelancer(user_id):
    data = request.json
    preferred_freelancer_codes = data.get('preferred_freelancer_codes', [])

    if not preferred_freelancer_codes:
        return jsonify({"success": False, "message": "삭제할 선호하는 프리랜서 코드를 입력해주세요."}), 400

    # 선호하는 프리랜서 삭제 처리
    result = g.user_information_service.delete_preferred_freelancer(preferred_freelancer_codes)
    
    return jsonify(result), 200 if result['success'] else 400

# PUT /profile/user_information/{user_id}/change-password
@user_information_bp.route('/<user_id>/change-password', methods=['PUT'])
def change_password(user_id):
    data = request.json
    current_password = data.get('current_password')
    new_password = data.get('new_password')
    confirm_new_password = data.get('confirm_new_password')

    # 비밀번호 필수 입력 체크
    if not current_password or not new_password or not confirm_new_password:
        return jsonify({'success': False, 'message': '모든 비밀번호 필드를 입력해주세요.'}), 400

    # LoginService 객체 생성
    login_service = LoginService()

    # 비밀번호 변경 처리
    result = login_service.change_password(user_id, current_password, new_password, confirm_new_password)

    # 결과 반환
    return jsonify(result), 200 if result['success'] else 400

# GET /profile/user_information/{user_id}/check-inquiry-state
@user_information_bp.route('/<user_id>/check-inquiry-state', methods=['GET'])
def check_inquiry_state(user_id):
    inquiry_state = g.user_information_service.confirm_inquiry_state(user_id)

    if inquiry_state is not None:
        return jsonify({'inquiry_state': inquiry_state}), 200
    else:
        return jsonify({'success': False, 'message': '문의 상태를 확인할 수 없습니다.'}), 404
    
# GET /profile/user_information/{user_id}/check-pretest-state
@user_information_bp.route('/<user_id>/check-pretest-state', methods=['GET'])
def check_pretest_state(user_id):
    pretest_state = g.user_information_service.confirm_pretest_state(user_id)

    if pretest_state is not None:
        return jsonify({'pretest_state': pretest_state}), 200
    else:
        return jsonify({'success': False, 'message': 'pretest 시행 여부를 확인할 수 없습니다.'}), 404