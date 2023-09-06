<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IMCPayment431.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Credit Card Payment</title>
    <link href="style.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript">
        function UpdateOrder() {

          
            var amount = document.forms[0].hiddenAmount.value;
            var auth = document.forms[0].hiddenAuth.value;
            var cc = document.forms[0].cardnumber.value;
            var cc1 = cc.substring(0, 1);
            var cctype = null;
            var cardtype = "";

            switch (cc1) {
                case "3": cctype = 1; cardtype = "American Express"; break;
                case "4": cctype = 4; cardtype = "Visa"; break;
                case "5": cctype = 3; cardtype = "Mastercard"; break;
                case "6": cctype = 2; cardtype = "Discover"; break;
                default: cctype = null; cardtype = "";
            }

            if (amount != null && amount != "") {
                try {
                    amount = amount.replace(",", "");
                    parent.document.all["imc_creditcardpayment"].DataValue = parseFloat(amount);
                    parent.document.all["imc_creditcardauthorization"].DataValue = auth;
                    parent.document.all["imc_cardtype"].DataValue = cctype;
                    
                }
                catch (err) {
                  
                    alert('Could not copy Charge Amount, Transaction ID, and Card Type - ' + cardtype + ' to the Order Form due to security.\nPlease copy them manually.');
                }
            }
           
            return true;
        }


        function form_validation(myForm) {

            if (myForm.address.value == "") {
                alert("You must enter BILLING STREET ADDRESS.");
                myForm.address.focus();
                return (false);
            }

            if (myForm.cvv.value=="") {
                alert("You must enter CVV code.");
                myForm.cvv.focus();
                return (false);
            
            }

            /*
            if (myForm.zipcode.value == "") {
            alert ("You must enter ZIPCODE.");
            myForm.zipcode.focus();
            return (false);
            }
	
            var filter  = /^([0-9\-])+$/;
            if (!filter.test(myForm.zipcode.value)){
            alert ("You must provide a valid ZIPCODE.");
            myForm.zipcode.focus();
            return (false);
            }
            */
            if (myForm.cardnumber.value == "") {
                alert("You must enter CREDIT CARD NUMBER.");
                myForm.cardnumber.focus();
                return (false);
            }

            var filter2 = /^([0-9\-])+$/;
            if (!filter2.test(myForm.cardnumber.value)) {
                alert("You must provide a valid CREDIT CARD NUMBER.");
                myForm.cardnumber.focus();
                return (false);
            }

            if (myForm.amount.value == "") {
                alert("You must enter CHARGE AMOUNT.");
                myForm.amount.focus();
                return (false);
            }

            var filter3 = /^([0-9\.\$\,])+$/;
            if (!filter3.test(myForm.amount.value)) {
                alert("You must provide a valid CHARGE AMOUNT.");
                myForm.amount.focus();
                return (false);
            }

            if (myForm.month.value == "0") {
                alert("You must select MONTH.");
                myForm.month.focus();
                return (false);
            }

            if (myForm.year.value == "0") {
                alert("You must select YEAR.");
                myForm.year.focus();
                return (false);
            }

            return (true);
        }
    </script>
</head>
<body onload="javascript:UpdateOrder();">
    <div class="wrapper">
        <form id="Form1" method="post" runat="server" onsubmit="return form_validation(this)">
        <table cellspacing="0" cellpadding="5" width="400">
            <tr><td class="header" colspan="2">
                    <h4>Credit Card Payment</h4>
                    Please fill in all information and click Process Card.
                </td>
            </tr>
            <tr>
                <td class="normal">
                    Billing Street Address<br />
                    <asp:TextBox ID="address" runat="server" MaxLength="100" CssClass="normal" Columns="40"></asp:TextBox>
                </td>
                <td class="normal">
                    Zipcode<br />
                    <asp:TextBox ID="zipcode" runat="server" MaxLength="10" CssClass="normal" Columns="20"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td class="normal">
                    Credit Card Number<br />
                    <asp:TextBox ID="cardnumber" runat="server" MaxLength="19" CssClass="normal" Columns="40"></asp:TextBox>
                </td>
                <td class="normal">
                    Charge Amount<br />
                    <asp:TextBox ID="amount" runat="server" MaxLength="19" CssClass="normal" Columns="20"></asp:TextBox>
                </td>
            </tr>
            <tr><td class="normal">Card Security Code
             <asp:TextBox ID="cvv" runat="server" MaxLength="19" CssClass="normal" Columns="40"></asp:TextBox>
            </td></tr>
            <tr>
                <td class="normal">
                    Expiration Date<br />
                    <table cellspacing="0" cellpadding="0">
                        <tr>
                            <td class="normal">
                                Month<br />
                                <asp:DropDownList ID="month" CssClass="normal" runat="server">
                                    <asp:ListItem Value="0">Select</asp:ListItem>
                                    <asp:ListItem Value="1">01 - January</asp:ListItem>
                                    <asp:ListItem Value="2">02 - February</asp:ListItem>
                                    <asp:ListItem Value="3">03 - March</asp:ListItem>
                                    <asp:ListItem Value="4">04 - April</asp:ListItem>
                                    <asp:ListItem Value="5">05 - May</asp:ListItem>
                                    <asp:ListItem Value="6">06 - June</asp:ListItem>
                                    <asp:ListItem Value="7">07 - July</asp:ListItem>
                                    <asp:ListItem Value="8">08 - August</asp:ListItem>
                                    <asp:ListItem Value="9">09 - September</asp:ListItem>
                                    <asp:ListItem Value="10">10 - October</asp:ListItem>
                                    <asp:ListItem Value="11">11 - November</asp:ListItem>
                                    <asp:ListItem Value="12">12 - December</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td style="width: 20px;">
                                &nbsp;
                            </td>
                            <td class="normal">
                                Year<br />
                                <asp:DropDownList ID="year" CssClass="normal" runat="server">
                                    <asp:ListItem Value="0">Select</asp:ListItem>
                                    <asp:ListItem Value="2011">2011</asp:ListItem>
                                    <asp:ListItem Value="2012">2012</asp:ListItem>
                                    <asp:ListItem Value="2013">2013</asp:ListItem>
                                    <asp:ListItem Value="2014">2014</asp:ListItem>
                                    <asp:ListItem Value="2015">2015</asp:ListItem>
                                    <asp:ListItem Value="2016">2016</asp:ListItem>
                                    <asp:ListItem Value="2017">2017</asp:ListItem>
                                    <asp:ListItem Value="2018">2018</asp:ListItem>
                                    <asp:ListItem Value="2019">2019</asp:ListItem>
                                    <asp:ListItem Value="2020">2020</asp:ListItem>
                                    <asp:ListItem Value="2021">2021</asp:ListItem>
                                    <asp:ListItem Value="2022">2022</asp:ListItem>
                                    <asp:ListItem Value="2023">2023</asp:ListItem>
                                    <asp:ListItem Value="2024">2024</asp:ListItem>
                                    <asp:ListItem Value="2025">2025</asp:ListItem>
                                    <asp:ListItem Value="2026">2026</asp:ListItem>
                                    <asp:ListItem Value="2009">2027</asp:ListItem>
                                    <asp:ListItem Value="2010">2028</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                        </tr>
                    </table>
                </td>
                <td class="normal" style="vertical-align: bottom;">
                    <asp:Button ID="btnSubmit" runat="server" Text="Process Card" OnClick="btnSubmit_Click" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <asp:Label ID="lblMessage" runat="server" CssClass="normal" Font-Bold="true" Text="&nbsp;"></asp:Label>
                    <input type="hidden" id="hiddenAmount" runat="server" />
                    <input type="hidden" id="hiddenAuth" runat="server" />
                </td>
            </tr>
        </table>
        </form>
    </div>
</body>
</html>
