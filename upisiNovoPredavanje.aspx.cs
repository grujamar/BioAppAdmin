using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

public partial class upisiNovoPredavanje : System.Web.UI.Page
{
    //Lofg4Net declare log variable
    private static readonly ILog log = LogManager.GetLogger(System.Reflection.MethodBase.GetCurrentMethod().DeclaringType);
    public string SetLightGray = Constants.SetLightGray;
    public string SetWhite = Constants.SetWhite;
    public string SetDarkGray = Constants.SetDarkGray;

    protected void Page_Load(object sender, EventArgs e)
    {
        Utility utility = new Utility();
        bool ConnectionActive = utility.IsAvailableConnection();
        if (!ConnectionActive)
        {
            Response.Redirect("GreskaBaza.aspx", false);
        }
        AvoidCashing();

        try
        {
            string encryptedParameters = Request.QueryString["d"];
            //log.Info(" encryptedParameters on Index page - " + encryptedParameters);

            if ((encryptedParameters != string.Empty) && (encryptedParameters != null))
            {
                // replace encoded plus sign "%2b" with real plus sign +
                encryptedParameters = encryptedParameters.Replace("%2b", "+");

                string decryptedParameters = AuthenticatedEncryption.AuthenticatedEncryption.Decrypt(encryptedParameters, Constants.CryptKey, Constants.AuthKey);

                if (decryptedParameters == null)
                {
                    throw new Exception("decryptedParameters error. ");
                }

                HttpRequest req = new HttpRequest("", "http://www.pis.rs", decryptedParameters);

                string data = req.QueryString["IDTerminPredavanja"];

                Session["Predavanje_idTerminPredavanjaIzmena"] = data;

                if (!Page.IsPostBack)
                {
                    Session["UpisiNovoPredavanje-idOsoba"] = 0;
                    Session["UpisiNovoPredavanje_uspesnoUpisano"] = 0;

                    if (Convert.ToInt32(Session["Predavanje_idTerminPredavanjaIzmena"]) == 0)
                    {
                        int IDLokacija = Convert.ToInt32(Session["NovoPredavanje-idLokacija"]);
                        List<int> predmetiList = new List<int>();
                    }
                }
            }
            else
            {
                Response.Redirect("GreskaTerminPredavanja.aspx", false);
                log.Error("Error on Index page. ");
            }
        }
        catch (Exception ex)
        {
            Response.Redirect("GreskaTerminPredavanja.aspx", false);
            log.Error("Error. " + ex);
        }
    }

    private void AvoidCashing()
    {
        Response.Cache.SetNoStore();
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
    }

    protected void btnBack_Click(object sender, EventArgs e)
    {
        string pageName = "Index.aspx";
        PageToRedirect(pageName);
    }

    protected void btnStartPage_Click(object sender, EventArgs e)
    {
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

    public List<string> getPredmetiNaziv(Utility utility, List<int> predmetiList, int idOsoba)
    {
        List<string> predmeti = new List<string>();

        try
        {
            foreach (var idpredmet in predmetiList)
            {
                string predmet = utility.getPredmetNaziv(idOsoba, idpredmet);
                log.Info(" Predmeti: " + predmet);
                predmeti.Add(predmet);
            }
        }
        catch (Exception ex)
        {
            log.Error("Error in function getPredmetiNaziv. " + ex.Message);
        }
        return predmeti;
    }

    protected void CheckBoxList1_ServerValidation(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            Utility utility = new Utility();
            // Create the list to store.
            List<int> CheckBoxList = new List<int>();

            List<int> BrojAkreditacijeList = new List<int>();
            // Loop through each item.
            foreach (ListItem item in CheckBoxList1.Items)
            {
                if (item.Selected)
                {
                    // If the item is selected, add the value to the list.
                    CheckBoxList.Add(Convert.ToInt32(item.Value));
                    int brojAkreditacije = utility.getBrojAkreditacije(item.ToString());
                    BrojAkreditacijeList.Add(brojAkreditacije);
                }
            }

            Session["UpisiNovoPredavanje_predmetiList"] = CheckBoxList;

            int sizeOfList = CheckBoxList.Count;
            args.IsValid = Utils.ValidateListSize(sizeOfList, BrojAkreditacijeList, out ErrorMessage);
            cvCheckbox.ErrorMessage = ErrorMessage;
        }
        catch (Exception)
        {
            cvCheckbox.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void increasePredmetiList()
    {
        try
        {
            List<string> PredmetiList = new List<string>();
            HtmlGenericControl li;
            for (int i = 0; i < CheckBoxList1.Items.Count; i++)
            {
                if (CheckBoxList1.Items[i].Selected)
                {
                    li = new HtmlGenericControl("li");
                    li.Attributes.Add("class", "submit-label ml-2");
                    li.InnerText = CheckBoxList1.Items[i].Text;
                    PredmetiList.Add(li.InnerText);
                    //predmetiList.Controls.Add(li);
                }
            }
            //Session["UpisiNovoPredavanje_predmetiList"] = PredmetiList;
        }
        catch (Exception ex)
        {
            log.Error("Error in function increasePredmetiList. " + ex.Message);
            throw new Exception();
        }
    }

    protected void Cvizbor_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            string IDItem = "0";

            args.IsValid = Utils.ValidateDropDownList(ddlizbor.SelectedValue, IDItem, "Tip predavanja je obavezno polje. ", out ErrorMessage);
            cvizbor.ErrorMessage = ErrorMessage;
        }
        catch (Exception)
        {
            cvizbor.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }


    protected void ddlizbor_SelectedIndexChanged(object sender, EventArgs e)
    {
        int SelectedValue = Convert.ToInt32(ddlizbor.SelectedValue);
        if (SelectedValue != 0)
        {
            Session["UpisiNovoPredavanje-idTipPredavanja"] = SelectedValue;
        }
    }


    ///-------------------------------------------------------------------------------------------

    public void SetFocusOnTextbox()
    {
        try
        {
            if (Session["Predavanja-event_controle"] != null)
            {
                TextBox controle = (TextBox)Session["Predavanja-event_controle"];
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
            if (Session["Predavanja-event_controle-DropDownList"] != null)
            {
                DropDownList padajucalista = (DropDownList)Session["Predavanja-event_controle-DropDownList"];
                //padajucalista.Focus();
                ScriptManager.RegisterStartupScript(Page, Page.GetType(), "foc", "document.getElementById('" + padajucalista.ClientID + "').focus();", true);
            }
        }
        catch (InvalidCastException inEx)
        {
            log.Error("Problem with setting focus on control. Error: " + inEx);
        }
    }

    /***************************************************/

    protected void ddlIDOsoba_SelectedIndexChanged(object sender, EventArgs e)
    {
        int SelectedValue = Convert.ToInt32(ddlIDOsoba.SelectedValue);
        if (SelectedValue != 0)
        {
            Session["UpisiNovoPredavanje-idOsoba"] = SelectedValue;
        }
        else
        {
            Session["UpisiNovoPredavanje-idOsoba"] = 0;
        }
    }


    protected void CvIDOsoba_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            string IDItem = "0";

            args.IsValid = Utils.ValidateDropDownList(ddlIDOsoba.SelectedValue, IDItem, "Osoba je obavezno polje. ", out ErrorMessage);
            cvIDOsoba.ErrorMessage = ErrorMessage;
        }
        catch (Exception)
        {
            cvIDOsoba.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }


    protected void btnInsert_Click(object sender, EventArgs e)
    {
        try
        {
            Page.Validate("AddCustomValidatorToGroup");

            if (Page.IsValid)
            {
                TimeSpan pocetak = TimeSpan.Parse(txtTimeStart.Text);
                TimeSpan kraj = TimeSpan.Parse(txtTimeEnd.Text);
                decimal procenatZaPriznavanje = 50.00m;
                int IdOsoba = Convert.ToInt32(Session["UpisiNovoPredavanje-idOsoba"]);
                int IdLokacija = Convert.ToInt32(Session["NovoPredavanje-idLokacija"]);
                DateTime datum = Convert.ToDateTime(Session["NovoPredavanje-IzabraniDatum"]);
                int idTipPredavanja = Convert.ToInt32(Session["UpisiNovoPredavanje-idTipPredavanja"]);
                List<int> CheckBoxListFinal = new List<int>();
                CheckBoxListFinal = (List<int>)Session["UpisiNovoPredavanje_predmetiList"];

                Utility utility = new Utility();

                utility.spUpisivanjeOdrzanogPredavanjaAdmin(IdLokacija, datum, pocetak, kraj, procenatZaPriznavanje, IdOsoba, CheckBoxListFinal, idTipPredavanja, out int result);
                if (result != 0)
                {
                    throw new Exception("Result from database is diferent from 0. Result is: " + result);
                }
                else
                {
                    Session["UpisiNovoPredavanje_uspesnoUpisano"] = 1;
                    Response.Redirect("novoPredavanje.aspx", false);
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

    protected void cvTimeStart_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage1 = string.Empty;
            args.IsValid = Utils.ValidateTimeStartEnd(txtTimeStart.Text, out ErrorMessage1);
            cvTimeStart.ErrorMessage = ErrorMessage1;
        }
        catch (Exception)
        {
            cvTimeStart.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void cvTimeEnd_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage1 = string.Empty;
            args.IsValid = Utils.ValidateTimeStartEnd(txtTimeEnd.Text, out ErrorMessage1);
            cvTimeEnd.ErrorMessage = ErrorMessage1;
        }
        catch (Exception)
        {
            cvTimeEnd.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }
}