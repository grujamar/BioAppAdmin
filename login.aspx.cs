using log4net;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login : System.Web.UI.Page
{
    //Lofg4Net declare log variable
    private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);

    protected void Page_Load(object sender, EventArgs e)
    {
        Utility utility = new Utility();
        bool ConnectionActive = utility.IsAvailableConnection();
        if (!ConnectionActive)
        {
            Response.Redirect("GreskaBaza.aspx", false); // this will tell .NET framework not to stop the execution of the current thread and hence the error will be resolved.
        }
        AvoidCashing();

        try
        {
            if (!Page.IsPostBack)
            {
                log.Info("Admin aplication successfully start.");
            }
        }
        catch (Exception ex)
        {
            Response.Redirect("GreskaStranica.aspx", false);
            log.Error("Error. " + ex);
        }
    }

    private void AvoidCashing()
    {
        Response.Cache.SetNoStore();
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
    }

    protected void LoginButton_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                int IDLogAdmin = 0;
                int Result = 0;

                Utility utility = new Utility();

                utility.loginAdmin(txtUsername.Text, txtPassword.Text, out IDLogAdmin, out Result);
                log.Debug("Login Admin: " + "Username - " + txtUsername.Text + " " + ". Password - " + txtPassword.Text + " " + ". IDLogAdmin - " + IDLogAdmin + " " + ". Rezultat - " + Result);

                if (Result != 0)
                {
                    throw new Exception("Result from database is diferent from 0. Result is: " + Result);
                }
                else
                {
                    Session["loginAdmin_IDLogAdmin"] = IDLogAdmin;

                    string PageToRedirect = "index.aspx";
                    Response.Redirect(string.Format("~/" + PageToRedirect), false);
                }
            }
            else if (!Page.IsValid)
            {
                //ScriptManager.RegisterStartupScript(this, GetType(), "erroralertLogin", "erroralertLogin();", true);
            }
        }
        catch (Exception ex)
        {
            log.Error("Error while trying to LOGIN. " + ex.Message);
            ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
        }
    }

    protected void cvUsername_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string newUsername = txtUsername.Text;
        string errMessage = string.Empty;

        args.IsValid = Utils.ValidateEmptyField(newUsername, Constants.UsernameError, out errMessage);
        cvUsername.ErrorMessage = errMessage;
    }

    protected void cvPassword_ServerValidate(object source, ServerValidateEventArgs args)
    {
        string newPassword = txtPassword.Text;
        string errMessage = string.Empty;

        args.IsValid = Utils.ValidateEmptyField(newPassword, Constants.PasswordError, out errMessage);
        cvPassword.ErrorMessage = errMessage;
    }
}