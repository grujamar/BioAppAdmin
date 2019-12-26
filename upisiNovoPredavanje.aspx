<%@ Page Language="C#" AutoEventWireup="true" CodeFile="upisiNovoPredavanje.aspx.cs" Inherits="upisiNovoPredavanje" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upiši novo predavanja</title>
    <!--#include virtual="~/content/head.inc"-->
    <script src="js/jquery.tooltip.js" type="text/javascript"></script>
</head>
<body class="login-bg">
    <form id="form1" runat="server">
        <!--header start-->
        <header class="py-3" style="background-image: linear-gradient(to right, rgba(220, 220, 220,0.3), rgba(220, 220, 220,0.9))">
            <div class="container">
                <nav class="navbar navbar-expand-md navbar-light px-0">
                    <!--logo start-->
                    <div class="navbar-container" id="navbar-container">
                        <asp:Image id="logo" runat="server" CssClass="logo-image" imageurl="~/images/logo.png"/>
                        <asp:Label id="lblscnsnaziv" runat="server" CssClass="scns-name pl-1 pl-sm-4">                               
                            biološki fakultet                                    
                        </asp:Label>         
                    </div><!--logo end-->
                    <!--header navigation start-->
			        <div class="collapse navbar-collapse" id="main-menu">
				        <article class="navbar-nav ml-auto mt-2 px-lg-5">
                            <asp:Button ID="btnBack" runat="server" Text="Nazad" CssClass="btn btn-outline-secondary ml-4 px-md-3 py-md-1" OnClick="btnBack_Click" OnClientClick="unhook()"/>
				        </article>                        
			        </div><!--header navigation end-->
                </nav>
            </div>
        </header><!--header end-->
        <!--main start-->
        <main>
            <div id="beforeStarting" runat="server">
                <div class="container">
                    <div class="row">

                    </div>
                    <!--div ddlLocation start-->
                    <div id="submitInsert1" class="col-12 col-lg-2 mb-1 mb-md-4 mt-md-4">
                        <asp:Label id="spanIDOsoba" runat="server" CssClass="submit-span">*</asp:Label><asp:Label id="lblIDOsoba" runat="server" CssClass="submit-label ml-2">Osoba:</asp:Label> 
                    </div>
                    <div class="col-12 col-lg-10">
                        <div id="submitInsert" class="row">
                            <div class="col-12 mb-1 pr-5">
                                <asp:DropDownList ID="ddlIDOsoba" runat="server" AppendDataBoundItems="True" AutoPostBack="True" CssClass="submit-dropdownlist" OnSelectedIndexChanged="ddlIDOsoba_SelectedIndexChanged" TabIndex="1" DataSourceID="dsOsoba" DataTextField="PunoImeLat" DataValueField="ID">
                                <asp:ListItem Selected="True" Value="0">--Izaberite--</asp:ListItem>
                                </asp:DropDownList>                   
                                <asp:SqlDataSource ID="dsOsoba" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT DISTINCT TOP (100) PERCENT dbo.KorisnickiNalog.ID, dbo.NastavniciKursevi.PunoImeLat
                                    FROM            dbo.NastavniciKursevi INNER JOIN
                                                             dbo.KorisnickiNalog ON dbo.NastavniciKursevi.KorisnickiNalog = dbo.KorisnickiNalog.KorisnickiNalog INNER JOIN
                                                             dbo.Semestar ON dbo.NastavniciKursevi.IDSemestar = dbo.Semestar.IDSemestar
                                    WHERE        (dbo.Semestar.Trenutno = 1)
                                    ORDER BY dbo.NastavniciKursevi.PunoImeLat"></asp:SqlDataSource>
                            </div>
                            <div class="col-12 mb-1">
                                <asp:CustomValidator runat="server" id="cvIDOsoba" controltovalidate="ddlIDOsoba" errormessage="" OnServerValidate="CvIDOsoba_ServerValidate" CssClass="submit-customValidator" Display="Dynamic" ForeColor="Red" ValidateEmptyText="true" ValidationGroup="AddCustomValidatorToGroup"/>
                            </div>
                        </div>
                    </div><!--div ddlLocation end-->
                    <!--section checkbox start-->
                    <section class="checkbox-section">
                        <asp:Label 
                            ID="lblpredmeti"
                            runat="server" 
                            Text="Izaberite predmete" 
                            AssociatedControlID="CheckBoxList1"
                            Font-Underline="true"
                            Font-Bold="true"
                            Font-Size="Medium"
                            />
                        <asp:CheckBoxList 
                            ID="CheckBoxList1"
                            runat="server"
                            Font-Italic="false"
                            Font-Names="Times New Roman"
                            CssClass="mycheckbox"
                            Font-Size="Medium" DataSourceID="dsPredmeti" DataTextField="NazivPredmeta" DataValueField="IDPredmet"
                            >
                            <asp:ListItem></asp:ListItem>
                        </asp:CheckBoxList>
                        <asp:SqlDataSource ID="dsPredmeti" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT IDPredmet, NazivPredmeta, BrojAkreditacije FROM vPredavanjaNastavnika WHERE (IDOsoba = @idosoba) ORDER BY NazivPredmeta, SifraPredmeta">
                            <SelectParameters>
                                <asp:SessionParameter Name="idosoba" SessionField="UpisiNovoPredavanje-idOsoba" DefaultValue="" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:CustomValidator ID="cvCheckbox" runat="server" ErrorMessage="" Display="Dynamic" ForeColor="Red" CssClass="submit-customValidator" OnServerValidate="CheckBoxList1_ServerValidation" ValidationGroup="AddCustomValidatorToGroup"></asp:CustomValidator>
                    </section><!--section checkbox end-->
                    <asp:ScriptManager ID="ScriptManager1" runat="server" />
                      <asp:UpdatePanel ID="UpdatePanel1" runat="server">     
                        <ContentTemplate>
                            <fieldset>
                                <div class="row izbor-section">
                                    <!--div ddlizbor start-->
                                    <div class="col-12 col-lg-2 mb-1 mb-md-4">
                                        <asp:Label id="spanizbor" runat="server" CssClass="submit-span">*</asp:Label><asp:Label id="lblizbor" runat="server" CssClass="submit-label ml-2">Tip predavanja:</asp:Label> 
                                    </div>
                                    <div class="col-12 col-lg-5">
                                        <asp:DropDownList ID="ddlizbor" runat="server" AppendDataBoundItems="True" CssClass="submit-dropdownlist" OnSelectedIndexChanged="ddlizbor_SelectedIndexChanged" TabIndex="2" DataSourceID="dsTipPredavanja" DataTextField="TipPredavanja" DataValueField="IDTipPredavanja">
                                        <asp:ListItem Selected="True" Value="0">--Izaberite--</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="dsTipPredavanja" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT [IDTipPredavanja], [TipPredavanja] FROM [vTipPredavanja]"></asp:SqlDataSource>
                                    </div>
                                    <div class="col-12 col-lg-5 mb-3 mb-lg-0">
                                        <asp:CustomValidator runat="server" id="cvizbor" controltovalidate="ddlizbor" errormessage="" OnServerValidate="Cvizbor_ServerValidate" CssClass="submit-customValidator" Display="Dynamic" ForeColor="Red" ValidateEmptyText="true" ValidationGroup="AddCustomValidatorToGroup"/>
                                    </div><!--div ddlizbor end-->
                                </div>
                            </fieldset>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    <div class="row">
                        <div class="col-12 col-md-4 mb-1 text-left">
                                <section class="right-section mt-4 mb-lg-5">
                                    <div class="mb-2">
                                        <asp:Label id="lblTimeStart" runat="server" style="font-weight:bold;font-size:13px;">Početak</asp:Label>
                                        <asp:TextBox ID="txtTimeStart" runat="server" CssClass="submit-textbox" maxlength="8" TabIndex="3" ValidationGroup="ChangeTimeValidatorToGroup"></asp:TextBox>
                                        <asp:CustomValidator runat="server" id="cvTimeStart" controltovalidate="txtTimeStart" errormessage="" OnServerValidate="cvTimeStart_ServerValidate" Display="Dynamic" ForeColor="Red" style="font-size:13px; font-weight:bold;" ValidateEmptyText="true"/>
                                    </div>
                                    <div class="mb-2">
                                        <asp:Label id="lblTimeEnd" runat="server" style="font-weight:bold;font-size:13px;">Kraj</asp:Label>
                                        <asp:TextBox ID="txtTimeEnd" runat="server" CssClass="submit-textbox" maxlength="8" TabIndex="4" ValidationGroup="ChangeTimeValidatorToGroup"></asp:TextBox>
                                        <asp:CustomValidator runat="server" id="cvTimeEnd" controltovalidate="txtTimeEnd" errormessage="" OnServerValidate="cvTimeEnd_ServerValidate" Display="Dynamic" ForeColor="Red" style="font-size:13px; font-weight:bold;" ValidateEmptyText="true"/>
                                    </div>
                                    <div class="mb-2 mt-4">

                                    </div>
                                </section>
                            </div>
                    </div>
                    <!--section search start-->
                    <section class="search-section py-1 py-md-2">
                        <div id="buttonStartVisible" class="row" runat="server">
                            <!--div search start-->
                            <div class="col-12 col-md-4 mb-1">
                            </div>
                            <div class="col-12 col-md-4 mb-1 mb-4 text-center">
                                <asp:Button ID="btnInsert" runat="server" Text=">>>Upiši novo predavanje<<<" CssClass="btn btn-info" OnClick="btnInsert_Click" OnClientClick="unhook()" TabIndex="9"/>
                            </div>
                            <div class="col-12 col-md-4 mb-1">
                            </div><!--div search end-->
                        </div>
                        <div id="buttonEditVisible" class="row" runat="server">

                        </div>
                    </section><!--section search end-->
                </div>
            </div>
        </main><!--main end-->
    </form>
</body>
</html>
