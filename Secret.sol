pragma solidity ^0.4.11;
contract Secret {
	string private secret;	// 기밀 정보 문자열
	
	/// 생성자
	function Secret(string _secret) {
		secret = _secret;
	}
	
	/// 기밀 정보 문자열 설정
	function setSecret(string _secret) public {
		secret = _secret;
	}
}
