using System;
using System.Net;
using System.ServiceProcess;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PayPal.Payments.Common.Utility;
using PayPal.Payments.DataObjects;
using PayPal.Payments.Transactions;
using System.Drawing;

namespace System.Net
{
    using System.Security.Authentication;
    public static class SecurityProtocolTypeExtensions
    {
        public const SecurityProtocolType Tls12 = (SecurityProtocolType)SslProtocolsExtensions.Tls12;
        public const SecurityProtocolType Tls11 = (SecurityProtocolType)SslProtocolsExtensions.Tls11;
        public const SecurityProtocolType SystemDefault = (SecurityProtocolType)0;
    }
}
namespace System.Security.Authentication
{
    public static class SslProtocolsExtensions
    {
        public const SslProtocols Tls12 = (SslProtocols)0x00000C00;
        public const SslProtocols Tls11 = (SslProtocols)0x00000300;
    }
}
namespace IMCPayment431
{
       public partial class Default : System.Web.UI.Page

    {
            

        protected void Page_Load(object sender, EventArgs e)
        {

            // Code that runs on application startup
            // System.Net.ServicePointManager.SecurityProtocol |= System.Net.SecurityProtocolType.Tls12;
           
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            //**Add this line**
            System.Net.ServicePointManager.SecurityProtocol = System.Net.SecurityProtocolType.Tls12;
            //**Add this line**

            //Clean data
            lblMessage.Text = "";

            string strcardnumber = cardnumber.Text.Trim();
            strcardnumber = strcardnumber.Replace(" ", "");
            strcardnumber = strcardnumber.Replace("-", "");

            string stramount = amount.Text.Trim();
            stramount = stramount.Replace("$", "");
            stramount = stramount.Replace(",", "");

            string strexpiration = "";
            if (Convert.ToInt32(month.SelectedItem.Value) < 10)
            {
                strexpiration = "0";
            }
            strexpiration = strexpiration + month.SelectedItem.Value.ToString() + year.SelectedItem.Value.ToString().Substring(2, 2);

            string straddress = address.Text.Trim();
            string strzipcode = zipcode.Text.Trim();
            string strcvvcode = cvv.Text.Trim();


            // Create the Data Objects.
            // Create the User data object with the required user details.
            UserInfo User = new UserInfo(PayflowUtility.AppSettings("PayflowUser"), PayflowUtility.AppSettings("PayflowVendor"), PayflowUtility.AppSettings("PayflowPartner"), PayflowUtility.AppSettings("PayflowPassword"));

            // Create the Payflow  Connection data object with the required connection details.
            // The PAYFLOW_HOST property is defined in the Web config file.
            PayflowConnectionData Connection = new PayflowConnectionData();

            // Create a new Invoice data object with the Amount, Billing Address etc. details.
            Invoice Inv = new Invoice();

            // Set Amount.
            Currency Amt = new Currency(Convert.ToDecimal(stramount));
            Inv.Amt = Amt;
            Inv.Amt.Round = true;
            Inv.Amt.NoOfDecimalDigits = 2;
            //Inv.PoNum = "PO12345";
            //Inv.InvNum = "INV12345";

            // Set the Billing Address details.
            BillTo Bill = new BillTo();
            Bill.Street = straddress;
            Bill.Zip = strzipcode;
            Inv.BillTo = Bill;


            
            // Create a new Payment Device - Credit Card data object.
            // The input parameters are Credit Card Number and Expiration Date of the Credit Card.
            //CreditCard CC = new CreditCard("5105105105105100", "0115");
            //CC.Cvv2 = "023";
            CreditCard CC = new CreditCard(strcardnumber, strexpiration);
            CC.Cvv2 = strcvvcode;

            // Create a new Tender - Card Tender data object.
            CardTender Card = new CardTender(CC);


            // Create a new Sale Transaction.

            
            SaleTransaction Trans = new SaleTransaction(
                User, Connection, Inv, Card, PayflowUtility.RequestId);

            // Submit the Transaction
            Response Resp = Trans.SubmitTransaction();
            
            // if (true)
            if (Resp.TransactionResponse.Result == 0)                      
            {
                lblMessage.Text = "Transaction Successful. TransactionID = " + Resp.TransactionResponse.Pnref;
                lblMessage.ForeColor = System.Drawing.Color.Green;
                btnSubmit.Enabled = false;
                hiddenAmount.Value = Inv.Amt.ToString();
                hiddenAuth.Value = Resp.TransactionResponse.Pnref.ToString();
            }
            else
            {
                lblMessage.Text = "Transaction Failed. Message: " + Resp.TransactionResponse.RespMsg;
                lblMessage.ForeColor = System.Drawing.Color.Red;
                hiddenAmount.Value = "";
                hiddenAuth.Value = "";
            }

            /*
                        // Display the transaction response parameters.
                        if (Resp != null)
                        {
                            // Get the Transaction Response parameters.
                            TransactionResponse TrxnResponse = Resp.TransactionResponse;

                            if (TrxnResponse != null)
                            {
                                Response.Write("RESULT = " + TrxnResponse.Result);
                                Response.Write("PNREF = " + TrxnResponse.Pnref);
                                Response.Write("RESPMSG = " + TrxnResponse.RespMsg);
                                Response.Write("AUTHCODE = " + TrxnResponse.AuthCode);
                                Response.Write("AVSADDR = " + TrxnResponse.AVSAddr);
                                Response.Write("AVSZIP = " + TrxnResponse.AVSZip);
                                Response.Write("IAVS = " + TrxnResponse.IAVS);
                                Response.Write("CVV2MATCH = " + TrxnResponse.CVV2Match);
                                // If value is true, then the Request ID has not been changed and the original response
                                // of the original transction is returned. 
                                Response.Write("DUPLICATE = " + TrxnResponse.Duplicate);
                            }

                            // Get the Fraud Response parameters.
                            FraudResponse FraudResp = Resp.FraudResponse;

                            // Display Fraud Response parameter
                            if (FraudResp != null)
                            {
                                Response.Write("PREFPSMSG = " + FraudResp.PreFpsMsg);
                                Response.Write("POSTFPSMSG = " + FraudResp.PostFpsMsg);
                            }

                            // Display the response.
                            Response.Write(Environment.NewLine + PayflowUtility.GetStatus(Resp));

                            // Get the Transaction Context and check for any contained SDK specific errors (optional code).
                            Context TransCtx = Resp.TransactionContext;
                            if (TransCtx != null && TransCtx.getErrorCount() > 0)
                            {
                                Response.Write(Environment.NewLine + "Transaction Errors = " + TransCtx.ToString());
                            }
                        }
             */


        }
    }
}