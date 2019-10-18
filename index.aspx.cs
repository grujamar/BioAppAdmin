using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Index : System.Web.UI.Page
{
    //Lofg4Net declare log variable
    private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public string SetLightGray = Constants.SetLightGray;
    public string SetWhite = Constants.SetWhite;
    public string SetDarkGray = Constants.SetDarkGray;
    public string SetRed = Constants.SetRed;
    public string SetGray = Constants.SetGray;

    protected void Page_Load(object sender, EventArgs e)
    {
        Utility utility = new Utility();
        bool ConnectionActive = utility.IsAvailableConnection();
        if (!ConnectionActive)
        {
            Response.Redirect("GreskaBaza.aspx", false);
        }
        AvoidCashing();
        ShowDatepicker();

        if (!Page.IsPostBack)
        {
            int IDLogAdmin = Convert.ToInt32(Session["loginAdmin_IDLogAdmin"]);
            if (IDLogAdmin != 0)
            {
                txtdate.BorderColor = ColorTranslator.FromHtml(SetGray);
                GridView1.Visible = false;
            }
            else
            {
                Response.Redirect("login.aspx", false);
                log.Info("Trying to open Index page without Login. IDLogAdmin is " + IDLogAdmin);
            }
        }
    }

    private void AvoidCashing()
    {
        Response.Cache.SetNoStore();
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
    }

    protected void ShowDatepicker()
    {
        //call function pickdate() every time after PostBack in ASP.Net
        ScriptManager.RegisterStartupScript(this, GetType(), "", "pickdate();", true);
        //Avoid: jQuery DatePicker TextBox selected value Lost after PostBack in ASP.Net
        //todo
        txtdate.Text = Request.Form[txtdate.UniqueID];
    }


    protected void btnLogout_Click(object sender, EventArgs e)
    {
        try
        {
            int Result = 0;

            Utility utility = new Utility();

            utility.logoutPredavanja(Convert.ToInt32(Session["loginAdmin_IDLogAdmin"]), out Result);
            log.Info("Logout Admin: " + " IDLogAdmin - " + Convert.ToInt32(Session["loginAdmin_IDLogAdmin"]) + " " + ". Rezultat - " + Result);

            if (Result != 0)
            {
                throw new Exception("Result from database is diferent from 0. Result is: " + Result);
            }
            else
            {
                Session["loginAdmin_IDLogAdmin"] = 0;

                Response.Redirect(string.Format("~/login.aspx"), false);
            }
        }
        catch (Exception ex)
        {
            log.Error("Error while trying to LOGOUT. " + ex.Message);
            ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
        }
    }

    protected void btnInsertNewLecture_Click(object sender, EventArgs e)
    {
        Response.Redirect("novoPredavanje.aspx", false);
    }


    protected void btnOpenModal_Click(object sender, EventArgs e)
    {
        divModal.Visible = true;
        txtUsername.Text = string.Empty;
    }

    protected void CloseModal_Click(object sender, EventArgs e)
    {
        divModal.Visible = false;
    }

    protected void btnChange_Click(object sender, EventArgs e)
    {
        try
        {
            if (Page.IsValid)
            {
                int Result = 0;

                Utility utility = new Utility();

                utility.changePassword(txtUsername.Text, txtPassword.Text, txtNewPassword.Text, out Result);
                log.Debug("Promena lozinke: " + " Korisnicko ime - " + txtUsername.Text + " " + " Stara lozinka - " + txtPassword.Text + " " + " Nova lozinka - " + txtNewPassword.Text + " " + ". Rezultat - " + Result);

                if (Result != 0)
                {
                    throw new Exception("Result from database is diferent from 0. Result is: " + Result);
                }
                else
                {
                    divModal.Visible = false;
                    ScriptManager.RegisterStartupScript(this, GetType(), "changepassOK", "changepassOK();", true);
                }
            }
            else if (!Page.IsValid)
            {
                divModal.Visible = true;
            }
        }
        catch (Exception ex)
        {
            log.Error("Error while trying to change password. " + ex.Message);
            divModal.Visible = false;
            ScriptManager.RegisterStartupScript(this, GetType(), "changepassFalse", "changepassFalse();", true);
        }
    }


    protected void cvUsername_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage1 = string.Empty;
            args.IsValid = Utils.ValidateEmptyField(txtUsername.Text, Constants.UsernameError, out ErrorMessage1);
            cvUsername.ErrorMessage = ErrorMessage1;
        }
        catch (Exception)
        {
            cvUsername.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void cvPassword_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage1 = string.Empty;
            args.IsValid = Utils.ValidateEmptyField(txtPassword.Text, Constants.PasswordError, out ErrorMessage1);
            cvPassword.ErrorMessage = ErrorMessage1;
        }
        catch (Exception)
        {
            cvPassword.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void cvNewPassword_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage1 = string.Empty;
            args.IsValid = Utils.ValidateEmptyField(txtNewPassword.Text, Constants.NewPasswordError, out ErrorMessage1);
            cvNewPassword.ErrorMessage = ErrorMessage1;
        }
        catch (Exception)
        {
            cvNewPassword.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void cvRepeatNewPassword_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            if (txtNewPassword.Text != string.Empty)
            {
                args.IsValid = txtRepeatNewPassword.Equals(txtNewPassword.Text);
                if (!args.IsValid)
                {
                    cvRepeatNewPassword.ErrorMessage = Constants.ComparePasswordError;
                }
            }
        }
        catch (Exception)
        {
            cvRepeatNewPassword.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }


    protected void Cvdate_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            if (txtdate.Text != string.Empty)
            {
                DateTime datum = DateTime.ParseExact(txtdate.Text, "dd.MM.yyyy", null);
                log.Debug("Datum je: " + datum);
                string ErrorMessage1 = string.Empty;

                args.IsValid = Utils.ValidateDate(datum, out ErrorMessage1);
                cvdate.ErrorMessage = ErrorMessage1;
                if (!args.IsValid)
                {
                    txtdate.BorderColor = ColorTranslator.FromHtml(SetRed);
                }
                else
                {
                    txtdate.BorderColor = ColorTranslator.FromHtml(SetGray);
                }
            }
            else
            {
                if (txtdate.Text == string.Empty)
                {
                    cvdate.ErrorMessage = "Datum je obavezno polje. ";
                    txtdate.BorderColor = ColorTranslator.FromHtml(SetRed);
                    args.IsValid = false;
                }
                else
                {
                    txtdate.BorderColor = ColorTranslator.FromHtml(SetGray);
                    args.IsValid = true;
                }
            }
        }
        catch (Exception ex)
        {
            log.Error("Greska prilikom validacije cvdate. " + ex.Message);
            txtdate.Text = string.Empty;
            cvdate.ErrorMessage = "Datum je u pogrešnom formatu. ";
            txtdate.BorderColor = ColorTranslator.FromHtml(SetRed);
            args.IsValid = false;
        }
    }


    
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        try
        {
            Page.Validate("AddCustomValidatorToGroup");

            if (Page.IsValid)
            {
                string FinalDate = string.Empty;
                string FormatDateTime = "dd.mm.yyyy";
                string FormatToString = "yyyy-mm-dd";
                parceDateTime(txtdate.Text, FormatDateTime, FormatToString, out FinalDate);

                Session["IzabraniDatum-Predavanja"] = FinalDate;
                GridView1.Visible = true;
                GridView1.DataBind();
            }
            else if (!Page.IsValid)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
            }
        }
        catch (Exception ex)
        {
            log.Error("Error while trying to search gridview. " + ex.Message);
            ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
        }
    }

    protected void parceDateTime(string dateTime, string FormatDateTime, string FormatToString, out string dateTimeFinal)
    {
        dateTimeFinal = string.Empty;
        DateTime FinalDate1 = DateTime.ParseExact(dateTime, FormatDateTime, CultureInfo.InvariantCulture);
        string FinalDate = FinalDate1.ToString(FormatToString);
        log.Debug("FinalDate to import: " + FinalDate);

        dateTimeFinal = FinalDate;
    }


    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    //-------------GRID VIEW ACTION--------------------------------------------------------------------------------------------------------------------------------------------------
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.Equals("ViewProfile"))
        {
            int rowno = Convert.ToInt32(e.CommandArgument);
            int IDTerminPredavanja = Convert.ToInt32(GridView1.DataKeys[rowno]["IDTerminPredavanja"]);
            string PageToRedirect = "predavanjePromena.aspx";

            try
            {
                string idTerminPredavanjaUrl = @"IDTerminPredavanja=" + IDTerminPredavanja + "&day=" + DateTime.Now.Day.ToString() + "&sec=" + DateTime.Now.Second.ToString(); //dan i sekunda se dodaju samo da string ne bi bio stalno isti
                string editParameters = AuthenticatedEncryption.AuthenticatedEncryption.Encrypt(idTerminPredavanjaUrl, Constants.CryptKey, Constants.AuthKey);
                editParameters = editParameters.Replace("+", "%252b");
                //log.Debug("Page to redirect. editParameters is - " + editParameters);
                Response.Redirect(string.Format("~/" + PageToRedirect + "?d={0}", editParameters), false);  
            }
            catch (Exception ex)
            {
                log.Info("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
                throw new Exception("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
            }
        }
    }

}