using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class novoPredavanje : System.Web.UI.Page
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
            GridView1.DataBind();

            int IDLogAdmin = Convert.ToInt32(Session["loginAdmin_IDLogAdmin"]);
            if (IDLogAdmin != 0)
            {
                txtdate.BorderColor = ColorTranslator.FromHtml(SetGray);
                ddlLocation.BorderColor = ColorTranslator.FromHtml(SetGray);
                if (Convert.ToInt32(Session["UpisiNovoPredavanje_uspesnoUpisano"]) != 1)
                {
                    Session["NovoPredavanje-idLokacija"] = 0;
                }
                GridView1.DataBind();
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

    protected void Cvdate_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            if (txtdate.Text != string.Empty)
            {
                DateTime datum = DateTime.ParseExact(txtdate.Text, "yyyy-mm-dd", null);
                log.Debug("Choosing Date for previous lecture is: " + datum);
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

    protected void CvLocation_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            string IDItem = "0";

            args.IsValid = Utils.ValidateDropDownList(ddlLocation.SelectedValue, IDItem, "Lokacija je obavezno polje. ", out ErrorMessage);
            cvLocation.ErrorMessage = ErrorMessage;
            if (!args.IsValid)
            {
                ddlLocation.BorderColor = ColorTranslator.FromHtml(SetRed);
            }
            else
            {
                ddlLocation.BorderColor = ColorTranslator.FromHtml(SetGray);
            }
        }
        catch (Exception)
        {
            cvLocation.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        int SelectedValue = Convert.ToInt32(ddlLocation.SelectedValue);
        if (SelectedValue != 0)
        {
            txtdate.BorderColor = ColorTranslator.FromHtml(SetGray);
            ddlLocation.BorderColor = ColorTranslator.FromHtml(SetGray);
            if (txtdate.Text != string.Empty)
            {
                Session["NovoPredavanje-IzabraniDatum"] = Convert.ToDateTime(txtdate.Text);
            }
            Session["NovoPredavanje-idLokacija"] = SelectedValue;
            GridView1.DataBind();
        }
        else
        {
            Session["NovoPredavanje-idLokacija"] = 0;
        }
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        Session["UpisiNovoPredavanje_uspesnoUpisano"] = 0;
        string pageName = "Index.aspx";
        PageToRedirect(pageName);
    }

    protected void PageToRedirect(string PageToRedirect)
    {
        try
        {
            Response.Redirect(PageToRedirect, false);
        }
        catch (Exception ex)
        {
            log.Info("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
        }
    }

    public void SetFocusOnTextbox()
    {
        try
        {
            if (Session["Fakture-event_controle"] != null)
            {
                TextBox controle = (TextBox)Session["Novo-predavanje-event_controle"];
                //controle.Focus();
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "foc", "document.getElementById('" + controle.ClientID + "').focus();", true);
            }
        }
        catch (InvalidCastException inEx)
        {
            log.Error("Problem with setting focus on control. Error: " + inEx);
        }
    }

    public void SetFocusOnDropDownLists()
    {
        try
        {
            if (Session["Novo-predavanje-event_controle-DropDownList"] != null)
            {
                DropDownList padajucalista = (DropDownList)Session["Novo-predavanje-event_controle-DropDownList"];
                //padajucalista.Focus();
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "foc", "document.getElementById('" + padajucalista.ClientID + "').focus();", true);
            }
        }
        catch (InvalidCastException inEx)
        {
            log.Error("Problem with setting focus on control. Error: " + inEx);
        }
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        //if (e.CommandName.Equals("ViewProfile"))
        //{
        //    int rowno = Convert.ToInt32(e.CommandArgument);
        //    int IDTerminPredavanja = Convert.ToInt32(GridView1.DataKeys[rowno]["IDTerminPredavanja"]);
        //    string PageToRedirect = "predavanjePromena.aspx";

        //    try
        //    {
        //        string idTerminPredavanjaUrl = @"IDTerminPredavanja=" + IDTerminPredavanja + "&day=" + DateTime.Now.Day.ToString() + "&sec=" + DateTime.Now.Second.ToString(); //dan i sekunda se dodaju samo da string ne bi bio stalno isti
        //        string editParameters = AuthenticatedEncryption.AuthenticatedEncryption.Encrypt(idTerminPredavanjaUrl, Constants.CryptKey, Constants.AuthKey);
        //        editParameters = editParameters.Replace("+", "%252b");
        //        //log.Debug("Page to redirect. editParameters is - " + editParameters);
        //        Response.Redirect(string.Format("~/" + PageToRedirect + "?d={0}", editParameters), false);
        //    }
        //    catch (Exception ex)
        //    {
        //        log.Info("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
        //        throw new Exception("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
        //    }
        //}
    }

    protected void btnSelectItems_Click(object sender, EventArgs e)
    {
        try
        {
            Page.Validate("AddCustomValidatorToGroup");

            if (Page.IsValid)
            {
                string PageToRedirect = "upisiNovoPredavanje.aspx";
                int idTerminPredavanjaIzmena = 0;
                try
                {
                    string idTerminPredavanjaIzmena1 = @"IDTerminPredavanja=" + idTerminPredavanjaIzmena;
                    //log.Info("idTerminPredavanjaIzmena is - " + idTerminPredavanjaIzmena1);
                    string editParameters = AuthenticatedEncryption.AuthenticatedEncryption.Encrypt(idTerminPredavanjaIzmena1, Constants.CryptKey, Constants.AuthKey);
                    editParameters = editParameters.Replace("+", "%252b");
                    log.Info("Page to redirect. editParameters is - " + editParameters);
                    Response.Redirect(string.Format("~/" + PageToRedirect + "?d={0}", editParameters), false);
                }
                catch (Exception ex)
                {
                    log.Info("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
                    throw new Exception("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
                }
            }
            else if (!Page.IsValid)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
            }
        }
        catch (Exception ex)
        {
            log.Error("Button submit error. " + ex.Message);
            ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
        }
    }
}