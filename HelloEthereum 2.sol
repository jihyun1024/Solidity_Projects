//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.4.11;
contract HelloEthereum {
	// 주석 넣기 1
	string public msg1;	
	
	string private msg2; // 주석 넣기 2
	
	/* 주석 넣기 3 */
	address public owner;
	
	uint8 public counter;
	
	/// 생성자
	constructor  (string memory _msg1)  {
		// msg1에 _msg1의 값을 대입
		msg1 = _msg1;
		
		// owner의 값에 이 컨트랙트를 생성한 계정 주소를 대입
		owner = msg.sender;
		
		// counter를 0으로 초기화
		counter = 0;
	}
	
	/// msg2 수정자 메서드
	function setMsg2(string memory _msg2) public {
		// if문 사용 예
		if(owner != msg.sender) {
			revert();
		} else {
			msg2 = _msg2;	
		}
	}
	
	// msg2의 접근자 메서드
	function getMsg2() view public returns(string memory) {
		return msg2;
	}
	
	function setCounter() public {
		// for문 사용 예
		for(uint8 i = 0; i < 3; i++) {
			counter++;
		}
	}
}
