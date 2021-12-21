


contract Bank {

    mapping(address => uint ) account_balances;

    function get_balances() external view virtual returns (uint) {
        return account_balances[msg.sender];
    }


    function transfer (address recipient, uint amount) virtual public {

        account_balances [msg.sender] -= amount;
        account_balances [recipient] += amount ;
    }


      function withdraw (uint amount) virtual public {

          account_balances[msg.sender] -= amount;
          payable (msg.sender).transfer(amount);

      }

      receive () external payable {
          account_balances[msg.sender] += msg.value;
      }

}


contract FunBank is Bank{

     uint number_of_accounts;

   // mapping(address => uint ) account_balances;
    mapping(address => uint ) account_info_map;

    struct BankAccountRecord {
        uint account_number;
        string fullName; 
        string profession;
        string DateofBirth;
        address wallet_addr;
        string customer_addr;

    }

    BankAccountRecord[] bankAccountRecords ;

    function register_account(
             string memory fullName_, 
             string memory profession_,
             string memory DateofBirth_,
             string memory customer_addr_ ) external {

        require(account_info_map[msg.sender] == 0 ,"Account already registered" );


     bankAccountRecords.push(
         BankAccountRecord ({
             account_number : ++number_of_accounts,
             fullName : fullName_,
             profession : profession_ ,
             DateofBirth : DateofBirth_,
             wallet_addr : msg.sender,
             customer_addr : customer_addr_
         })) ;
        
        account_info_map[msg.sender] = number_of_accounts;

             }

     modifier onlyRegistered(){
         require( account_info_map[msg.sender] > 0 , "User not Register , please register to use this method.");
         _;
     }

      function get_balances() external view onlyRegistered override returns (uint) {
        return account_balances[msg.sender];
    }


    function transfer (address recipient, uint amount) public override onlyRegistered {

        account_balances [msg.sender] -= amount;
        account_balances [recipient] += amount ;
    }


      function withdraw (uint amount) public override onlyRegistered {

          account_balances[msg.sender] -= amount;
          payable (msg.sender).transfer(amount);

      }

}

