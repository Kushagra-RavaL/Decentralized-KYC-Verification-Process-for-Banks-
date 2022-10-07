// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KYCProcess{
    
    address Admin;
    constructor() {
        Admin = msg.sender;
    }
    modifier OnlyAdmin() {
        require(msg.sender == Admin,"Only Admin Can Access !");
        _;
    }
// ------------- State Variables --------------
    address[] BankAddress;
    mapping(address => bool) ExistingBank;

// Struct For Bank ADDING NEW BANK
    struct Bank{
        string Bankname;
        address BankAdd;
        uint KYCcount;
        bool PermissionToadd;
        bool KYCPrivilage;
    }
    mapping (address =>Bank) BankDetails;
    function addNewBank(string memory _bankname, address bankAddress) OnlyAdmin public{
        BankDetails[bankAddress]=Bank(_bankname,bankAddress,0,false,false); // We can use this also but here in the bracket should be in order W/R to structure 
        BankAddress.push(bankAddress);
        ExistingBank[bankAddress] = true;
    }

// Struct For Customer ADDING NEW CUSTOMER
    struct Customer{
        string Custname;
        string CustLocation;
        address CustBank;
        bool KYCStatus;
    }
    mapping (string =>Customer) CustomerDetails;
    function addNewCustomerTobank(string memory _CustName, string memory _CustLocation, address _CustBank) public{
        require(ExistingBank[msg.sender] != false,"ONLY REGISTERED BANK CAN ADD CUSTOMER TO THE BANK");
        require(BankDetails[msg.sender].PermissionToadd != false,"BANK Dont have permission to Add New Customer");
        CustomerDetails[_CustName]=Customer(_CustName,_CustLocation,_CustBank,false);  // We can use this also but here in the bracket should be in order W/R to structure
    }

// ADDING REQUEST FOR KYC of the Customer
    function addNewCustomerRequestForKYC(string memory _CustName, address _CustBank) public{
        // string memory value;
        require(CustomerDetails[_CustName].KYCStatus != true,"Your KYC status is ALREADY True");
        require(BankDetails[_CustBank].KYCPrivilage !=false,"YOUR BANK DONT HAVE PRIVILAGE FOR KYC");
        CustomerDetails[_CustName].KYCStatus= true;
        BankDetails[_CustBank].KYCcount ++;
        // value = "Request accepted Successfully!";
        // return value;
    }

// ALLOW BANK FROM KYC PRIVILAGE
    function allowBankFromKYC(address bankAddress) public OnlyAdmin{
        BankDetails[bankAddress].KYCPrivilage = true;
    }

// BLOCK BANK FROM KYC
    function BlockBankFromKYC(address bankAddress) public OnlyAdmin{
        BankDetails[bankAddress].KYCPrivilage = false;
    }

// ALLOW BANK FROM ADDING NEW CUSTOMERs
    function allowBankfromAddingNewCustomers(address bankAddress) public OnlyAdmin{
        BankDetails[bankAddress].PermissionToadd = true;
    }

// BLOCK BANK FROM ADDING NEW CUSTOMERS
    function blockBankfromAddingNewCustomers(address bankAddress) public OnlyAdmin{
        BankDetails[bankAddress].PermissionToadd = false;
    }
// VIEW CUSTOMER DETAILS
    function viewCustomerData(string memory _CustName) public view returns(string memory,string memory,address,bool){
        return(CustomerDetails[_CustName].Custname,
               CustomerDetails[_CustName].CustLocation,
               CustomerDetails[_CustName].CustBank,
               CustomerDetails[_CustName].KYCStatus);
    }

    function ViewBankDetails(address bankAddress) public view returns(string memory,bool,bool,uint){
        return(BankDetails[bankAddress].Bankname,
        BankDetails[bankAddress].PermissionToadd,
        BankDetails[bankAddress].KYCPrivilage,
        BankDetails[bankAddress].KYCcount);
    }
}