pragma solidity ^0.4.11;
contract CircuitBreaker {
	bool public stopped;	// 값이 true이면 긴급 정지가 발동된 상태임
	address public owner;		
	bytes16 public message;

	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}

	/// 변수 stopped의 값을 확인하는 modifier
	modifier isStopped() {
		require(!stopped);
		_;
	}

	/// 생성자
	function CircuitBreaker() {
		owner = msg.sender;
		stopped = false;
	}
	
	/// stopped의 값을 변경
	function toggleCircuit(bool _stopped) public onlyOwner {
		stopped = _stopped;
	}
		
	/// message의 값을 변경하는 함수
	/// 변수 stopped의 값이 true이면 수정할 수 없음
	function setMessage(bytes16 _message) public isStopped {
		message = _message;
	}
}
