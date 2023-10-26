// The 'token_10142' program.
program token_10142.aleo {

    mapping balance: address => u64;
  
  record Token{
    owner: address,
    balance: u64,
  }

    transition mint(amount: u64) -> Token{
        return Token {
            owner: self.caller,
            balance: amount,
        };
    }

    transition transfer(receiver:address, amount: u64, input: Token) -> (Token, Token){
        let difference: u64 = input.balance - amount;
        let ori_owner: Token = Token {
            owner: self.caller,
            balance: difference,
        };

        let recipient: Token = Token{
            owner: receiver,
            balance: amount,
        };

        return (ori_owner, recipient);
    }


    transition transfer_public(receiver: address, amount: u64){
        return then finalize (self.caller, receiver, amount);
    }

    finalize transfer_public(sender: address, receiver: address, amount: u64){
        let sender_balance: u64 = Mapping::get(balance, sender);
        let difference: u64 = sender_balance - amount;
        Mapping::set(balance, sender, difference);

        let receiver_balance: u64 = Mapping::get(balance, receiver);
        Mapping::set(balance, sender, receiver_balance + amount);
    }


    transition transfer_public_to_private(receiver: address, amount: u64) -> Token{
        return Token {
            owner: receiver,
            balance: amount,
        } then finalize (self.caller, amount);
    }

    finalize transfer_public_to_private(sender: address, amount: u64) {
        let prev_balance: u64 = Mapping::get(balance, sender);
        Mapping::set(balance, sender, prev_balance - amount);
    }



    transition join(input: Token, input_two: Token) -> Token {
    let new: u64 = input.balance + input_two.balance;
    
    return Token {
        owner: self.caller,
        balance: new,
    };
  }


}
