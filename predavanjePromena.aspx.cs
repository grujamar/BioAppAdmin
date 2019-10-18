using log4net;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class predavanjePromena : System.Web.UI.Page
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
            //log.Debug("EncryptedParameters on predavanjePromena page - " + encryptedParameters);

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
                Session["predavanjePromena-IDTerminPredavanja"] = data;

                if (!Page.IsPostBack)
                {
                    txtIndexNumber.Attributes.Add("onkeydown", "if(event.which || event.keyCode){if ((event.which == 13) || (event.keyCode == 13)) {document.getElementById('" + btnAddIndex.UniqueID + "').click();return false;}} else {return true}; ");

                    //get IDLokacija with IDTerminPredavanja
                    int IDLokacije = utility.getIDLokacijeAdmin(Convert.ToInt32(data));
                    Session["predavanjePromena-IDLokacija"] = IDLokacije;




                }
            }
            else
            {
                Response.Redirect("GreskaTerminPredavanja.aspx", false);
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

    protected void Page_PreRenderComplete(object sender, EventArgs e)
    {
        //int count = CheckBoxList1.Items.Count;
        //foreach (ListItem item in CheckBoxList1.Items)
        //{
        //    string nesto = item.Text;
        //    int itemvalue = Convert.ToInt32(item.Value);
        //}
        Utility utility = new Utility();
        Check_CheckBoxList_BasedOnIDTerminPredavanja(utility, Session["predavanjePromena-IDTerminPredavanja"].ToString());
        Set_DropDownList_BasedOnIDTerminPredavanja(utility, Session["predavanjePromena-IDTerminPredavanja"].ToString());
    }


    protected void Check_CheckBoxList_BasedOnIDTerminPredavanja(Utility utility, string data)
    {
        try
        {
            List<int> IDPredmetiList = new List<int>();
            IDPredmetiList = utility.getCheckedIDPredmet(Convert.ToInt32(data));
            foreach (ListItem item in CheckBoxList1.Items)
            {
                if (!item.Selected)
                {
                    for (int j = 0; j < IDPredmetiList.Count; j++)
                    {
                        if (IDPredmetiList[j] == Convert.ToInt32(item.Value))
                            CheckBoxList1.Items.FindByValue(item.Value).Selected = true;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            log.Error("Error in fuction Check_CheckBoxList_BasedOnIDTerminPredavanja " + ex.Message);
            throw new Exception("Error in fuction Check_CheckBoxList_BasedOnIDTerminPredavanja " + ex.Message);
        }
    }

    protected void Set_DropDownList_BasedOnIDTerminPredavanja(Utility utility, string data)
    {
        try
        {
            int IdTipPredavanja = utility.getIDTipPredavanja(Convert.ToInt32(data));
            ddlizbor.SelectedValue = IdTipPredavanja.ToString();
        }
        catch (Exception ex)
        {
            log.Error("Error in fuction Set_DropDownList_BasedOnIDTerminPredavanja " + ex.Message);
            throw new Exception("Error in fuction Set_DropDownList_BasedOnIDTerminPredavanja " + ex.Message);
        }
    }

    protected void btnAddIndex_Click(object sender, EventArgs e)
    {
        try
        {
            Page.Validate("AddCustomValidatorToGroup");

            if (Page.IsValid)
            {
                Utility utility = new Utility();

                DateTime dateTime = DateTime.Now;
                DateTime dateOnly = dateTime.Date;
                TimeSpan timeOfDay = DateTime.Now.TimeOfDay;
                TimeSpan timeOnly = new TimeSpan(timeOfDay.Hours, timeOfDay.Minutes, timeOfDay.Seconds);

                int Result = 0;

                utility.upisivanjePrisustvaRucno(txtIndexNumber.Text, Convert.ToInt32(Session["predavanjePromena-IDLokacija"]), dateOnly, timeOnly, out Result);
                log.Info("upisivanjePrisustvaRucno : " + " BrojIndeksa - " + txtIndexNumber.Text + " " + ". IDLokacije - " + Convert.ToInt32(Session["predavanjePromena-IDLokacija"]) + " " + ". Datum - " + dateOnly + " " + ". Vreme - " + timeOnly + " " + ". Rezultat - " + Result);
                if (Result != 0)
                {
                    throw new Exception("Result from database is diferent from 0. Result is: " + Result);
                }
                else
                {
                    txtIndexNumber.Text = string.Empty;
                    GridView1.DataBind();
                    GridView2.DataBind();
                }
                Session["predavanje-event_controle"] = txtIndexNumber;
                SetFocusOnTextbox();
            }
            else if (!Page.IsValid)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
            }
        }
        catch (Exception ex)
        {
            log.Error("btnAddIndex submit error. " + ex.Message);
            ScriptManager.RegisterStartupScript(this, GetType(), "erroralert", "erroralert();", true);
            Session["predavanje-event_controle"] = txtIndexNumber;
            SetFocusOnTextbox();
        }
    }

    


    protected void btnBack_Click(object sender, EventArgs e)
    {
        string PageToRedirect = "Index.aspx";
        //int idTerminPredavanjaIzmena = 0;
        try
        {
            /*
            string idTerminPredavanjaIzmena1 = @"IDTerminPredavanja=" + idTerminPredavanjaIzmena;
            log.Info(Session["login-ImeLokacijeZaLog"].ToString() + " - " + "Back button. idTerminPredavanjaIzmena is - " + idTerminPredavanjaIzmena1);
            string editParameters = AuthenticatedEncryption.AuthenticatedEncryption.Encrypt(idTerminPredavanjaIzmena1, Constants.CryptKey, Constants.AuthKey);
            editParameters = editParameters.Replace("+", "%252b");
            log.Info(Session["login-ImeLokacijeZaLog"].ToString() + " - " + "Back button. Page to redirect. editParameters is - " + editParameters);
            */
            //Response.Redirect(string.Format("~/" + PageToRedirect + "?d={0}", editParameters), false);
            Response.Redirect(string.Format("~/" + PageToRedirect, false));
        }
        catch (Exception ex)
        {
            log.Info("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
            //throw new Exception("Error while opening the Page: " + PageToRedirect + " . Error message: " + ex.Message);
        }
    }

    protected void cvIndexNumber_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            args.IsValid = Utils.ValidateEmptyField(txtIndexNumber.Text, Constants.IDError, out ErrorMessage);
            cvIndexNumber.ErrorMessage = ErrorMessage;
        }
        catch (Exception)
        {
            cvIndexNumber.ErrorMessage = string.Empty;
            args.IsValid = false;
        }
    }

    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {

            bool DaLiSePrijavaOdnosiNaTrenutniTermin = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "DaLiSePrijavaOdnosiNaTrenutniTermin"));

            if (!DaLiSePrijavaOdnosiNaTrenutniTermin)
            {
                e.Row.BackColor = ColorTranslator.FromHtml(SetLightGray);
            }
            else
            {
                e.Row.BackColor = ColorTranslator.FromHtml(SetWhite);
            }


            e.Row.Cells[2].BackColor = ColorTranslator.FromHtml(Convert.ToString((DataBinder.Eval(e.Row.DataItem, "Boja"))));
        }
    }

    protected void CheckBoxList1_ServerValidation(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            Utility utility = new Utility();
            // Create the list to store.
            List<string> CheckBoxList = new List<string>();

            List<int> BrojAkreditacijeList = new List<int>();
            // Loop through each item.
            foreach (ListItem item in CheckBoxList1.Items)
            {
                if (item.Selected)
                {
                    // If the item is selected, add the value to the list.
                    CheckBoxList.Add(item.Value);
                    int brojAkreditacije = utility.getBrojAkreditacije(item.ToString());
                    BrojAkreditacijeList.Add(brojAkreditacije);
                }
            }

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


    ///---------------------------------IZBOR-----------------------------------------------------

    protected void Cvizbor_ServerValidate(object source, ServerValidateEventArgs args)
    {
        try
        {
            string ErrorMessage = string.Empty;
            string IDItem = "0";

            args.IsValid = Utils.ValidateIzbor(ddlizbor.SelectedValue, IDItem, out ErrorMessage);
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
            //ddlizbor.BorderColor = ColorTranslator.FromHtml(SetGray);
            Session["Predavanja-event_controle-DropDownList"] = ((DropDownList)sender);
            SetFocusOnDropDownLists();
        }
    }

    ///-------------------------------------------------------------------------------------------
    ///

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            bool DaLiSePrijavaOdnosiNaTrenutniTermin = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "DaLiSePrijavaOdnosiNaTrenutniTermin"));
            string TipStatusa = Convert.ToString(DataBinder.Eval(e.Row.DataItem, "TipStatusa"));

            if (!DaLiSePrijavaOdnosiNaTrenutniTermin)
            {
                e.Row.BackColor = ColorTranslator.FromHtml(SetLightGray);
                e.Row.Attributes["onmouseover"] = "onMouseOver('" + (e.Row.RowIndex + 1) + "')";
                e.Row.Attributes["onmouseout"] = "onMouseOut('" + (e.Row.RowIndex + 1) + "')";
            }
            else
            {
                e.Row.BackColor = ColorTranslator.FromHtml(SetWhite);
                e.Row.Attributes["onmouseover"] = "onMouseOver('" + (e.Row.RowIndex + 1) + "')";
                e.Row.Attributes["onmouseout"] = "onMouseOutWhite('" + (e.Row.RowIndex + 1) + "')";
            }

            e.Row.Cells[6].BackColor = ColorTranslator.FromHtml(Convert.ToString((DataBinder.Eval(e.Row.DataItem, "Boja"))));
        }
    }

    protected void Timer2_Tick(object sender, EventArgs e)
    {
        GridView1.DataBind();
        GridView gw = (GridView)UpdatePanel3.FindControl("GridView2");
        gw.DataBind();
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "TooltipImages", "TooltipImages()", true);
    }

    public void SetFocusOnTextbox()
    {
        try
        {
            if (Session["predavanje-event_controle"] != null)
            {
                TextBox controle = (TextBox)Session["predavanje-event_controle"];
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
}