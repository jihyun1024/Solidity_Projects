pragma solidity ^0.4.11;
contract Owned {
	address public owner;
	
	/// 접근 제어를 위한 modifier
	modifier onlyOwner() {
		require(msg.sender == owner);
		_;
	}
	
	/// 소유자 설정
	function owned() internal {
		owner = msg.sender;
	}
	
	/// 소유자 변경
	function changeOwner(address _newOwner) public onlyOwner {
		owner = _newOwner;
	}
}

contract Mortal is Owned {
	/// 컨트랙트를 소멸시키고 보유한 이더를 소유자에게 송금
	function kill() public onlyOwner {
		selfdestruct(owner);
	}
}

contract MortalSample is Mortal{
	string public someState;
	
	/// Fallback 함수
	function() payable {
	}
	
	/// 생성자
	function MortalSample() {
		// Owned에 정의된 owned 함수를 호출
		owned();
		
		// someState의 초깃값을 설정
		someState = "initial";
	}
}
