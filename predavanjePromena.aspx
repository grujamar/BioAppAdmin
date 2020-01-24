<%@ Page Language="C#" AutoEventWireup="true" CodeFile="predavanjePromena.aspx.cs" Inherits="predavanjePromena" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 5.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Predavanje promena</title>
    <!--#include virtual="~/content/head.inc"-->
    <!--Jquery BlockUI-->
    <script src="Js/jquery.blockUI.js"></script>
    <script src="js/jquery.tooltip.js" type="text/javascript"></script>
    <script type="text/javascript">
        function TooltipImages() {
            $(".gridImages").tooltip({
                track: true,
                delay: 0,
                showURL: false,
                fade: 100,
                bodyHandler: function () {
                    return $($(this).next().html());
                },
                showURL: false
            });
        }
        function onMouseOver(rowIndex) {
             document.getElementById("GridView1").rows[rowIndex].style.backgroundColor = "#d3ddcc";
        }
        function onMouseOut(rowIndex) {
            document.getElementById("GridView1").rows[rowIndex].style.backgroundColor = "#BEBEBE";
        }
        function onMouseOutWhite(rowIndex) {
            document.getElementById("GridView1").rows[rowIndex].style.backgroundColor = "#FFFFFF";
        }
        var new_var = true;
        window.onbeforeunload = function () {
            if (new_var) {
                return "Imate promene koje niste sačuvali, ako ih ostavite, oni će biti izgubljeni!!"                
            }
        }
        function unhook() {
            new_var = false;
        }
        function errorOpeningPage() {
            swal({
                title: 'Greška prilikom otvaranja stranice.',
                text: 'Pokušajte ponovo kasnije.',
                type: 'OK'
            });
        }
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#btnEdit').click(function () {
                $.blockUI({
                    message: '<p style="font-size:20px; font-weight: bold;"><b>Molimo sačekajte...</b></p><img src="throbber.gif" runat="server" style="width:35px;height:35px;"/>',
                    css: {
                        border: 'none',
                        padding: '15px',
                        backgroundColor: '#000',
                        '-webkit-border-radius': '10px',
                        '-moz-border-radius': '10px',
                        opacity: .5,
                        color: '#fff',
                        left: '25%',
                        width: '50%',
                        onBlock: function () {
                            pageBlocked = true;
                        }
                    }
                });
            });
        });
      </script>
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
                            <asp:Button ID="btnBack" runat="server" Text="Nazad" CssClass="btn btn-success btn-lg px-5" OnClick="btnBack_Click" OnClientClick="unhook()"/>
				        </article>                        
			        </div><!--header navigation end-->
                </nav>
            </div>
        </header><!--header end-->
        <!--main start-->
        <main>
            <asp:ScriptManager ID="ScriptManager1" runat="server" EnableCdn="true"/>
            <div id="afterStarting" runat="server" class="after-starting">
                <section class="my-2">
                    <div class="container">
                        <div class="row">
                            <div class="col-12 col-md-8 text-left">
                                <!--section checkbox start-->
                                <section class="checkbox-section">
                                    <asp:Label 
                                        ID="lblpredmeti"
                                        runat="server" 
                                        Text="Predmeti" 
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
                                        Font-Size="Medium" DataSourceID="dsPredmeti" DataTextField="NazivPredmeta" DataValueField="IDPredmet" TabIndex="1"
                                        >
                                        <asp:ListItem></asp:ListItem>
                                    </asp:CheckBoxList>
                                    <asp:SqlDataSource ID="dsPredmeti" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT TOP (100) PERCENT vPredavanjaNastavnika.IDPredmet, vPredavanjaNastavnika.NazivPredmeta, vPredavanjaNastavnika.BrojAkreditacije FROM vPredavanjaNastavnika INNER JOIN TerminPredavanja ON vPredavanjaNastavnika.IDOsoba = TerminPredavanja.IDOsobaPredavac WHERE (TerminPredavanja.IDTerminPredavanja = @idterminpredavanja) ORDER BY vPredavanjaNastavnika.NazivPredmeta, vPredavanjaNastavnika.SifraPredmeta">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="idterminpredavanja" SessionField="predavanjePromena-IDTerminPredavanja" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <asp:CustomValidator ID="cvCheckbox" runat="server" ErrorMessage="" Display="Dynamic" ForeColor="Red" CssClass="submit-customValidator" OnServerValidate="CheckBoxList1_ServerValidation" ValidationGroup="AddCustomValidatorToGroupChange"></asp:CustomValidator>
                                </section><!--section checkbox end-->
                                <section class="mb-5 search-section">
                                    <!--div ddlizbor start-->
                                    <div class="col-12 col-lg-4 mb-1 mb-md-4">
                                        <asp:Label id="spanizbor" runat="server" CssClass="submit-span">*</asp:Label><asp:Label id="lblizbor" runat="server" CssClass="submit-label ml-2">Tip predavanja:</asp:Label> 
                                    </div>
                                    <div class="col-12 col-lg-5">
                                        <asp:DropDownList ID="ddlizbor" runat="server" AppendDataBoundItems="True" CssClass="submit-dropdownlist" OnSelectedIndexChanged="ddlizbor_SelectedIndexChanged" TabIndex="2" DataSourceID="dsTipPredavanja" DataTextField="TipPredavanja" DataValueField="IDTipPredavanja">
                                        <asp:ListItem Selected="True" Value="0">--Izaberite--</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="dsTipPredavanja" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT [IDTipPredavanja], [TipPredavanja] FROM [vTipPredavanja]"></asp:SqlDataSource>
                                    </div>
                                    <div class="col-12 col-lg-5 mb-3 mb-lg-0">
                                        <asp:CustomValidator runat="server" id="cvizbor" controltovalidate="ddlizbor" errormessage="" OnServerValidate="Cvizbor_ServerValidate" CssClass="submit-customValidator" Display="Dynamic" ForeColor="Red" ValidateEmptyText="true" ValidationGroup="AddCustomValidatorToGroupChange"/>
                                    </div><!--div ddlizbor end-->
                                </section>
                                 <section class="mb-5">
                                    <div class="col-12">
                                        <asp:Button ID="btnEdit" runat="server" Text="Sačuvaj izmene" CssClass="btn btn-danger btn-lg px-5 pl-5" OnClick="btnEdit_Click" OnClientClick="unhook()"/>
                                    </div>
                                </section>
                            </div>
                            <div class="col-12 col-md-4 mb-1 text-left">
                                <section class="right-section mt-4 mb-lg-5">
                                    <div class="row">
                                        <div class="col-12 col-mb-5">
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
                                                <asp:Button ID="btnChangeTime" runat="server" CssClass="btn btn-outline-secondary btn-sm px-1 ml-5" Text="Promeni vreme termina" OnClick="btnChangeTime_Click" OnClientClick="unhook()"/><br>
                                                <asp:Label ID="errStoredProcedure" runat="server" style="font-size:13px; font-weight:bold;" ForeColor="Red"></asp:Label>
                                            </div>
                                        </div>
                                       
                                    </div>
                                </section>
                            </div>
                        </div>
                        <div class="row" runat="server" id="afterChangingTime1">
                            <div class="col-12 col-md-2 mb-1">
                            </div>
                            <div class="col-12 col-md-8 mb-1 text-center">
                                <asp:UpdatePanel id="UpdatePanel1" runat="server"  UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <fieldset>
                                            <div class="row">
                                                <div class="col-8">
                                                    <div class="row">
                                                        <div class="col-12 col-sm-6">
                                                            <asp:TextBox ID="txtIndexNumber" runat="server" CssClass="submit-textbox" maxlength="20" placeholder="Upišite ID" TabIndex="5"></asp:TextBox>
                                                            <br><p class="notification" style="margin-bottom: 1px;"><asp:Label id="lblnotification" runat="server" style="font-size:11px; font-weight: bold">Broj indeksa ili korisničko ime profesora.</asp:Label></p>
                                                        </div>
                                                        <div class="col-12 col-sm-6">
                                                            <asp:Button ID="btnAddIndex" runat="server" Text="+ Dodaj prisustvo" CssClass="btn btn-secondary px-3" OnClick="btnAddIndex_Click" OnClientClick="unhook()" TabIndex="6"/>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-4">
                                                    <asp:CustomValidator ID="cvIndexNumber" runat="server" ErrorMessage="" controltovalidate="txtIndexNumber" Display="Dynamic" ForeColor="Red" CssClass="submit-customValidator" ValidateEmptyText="true" OnServerValidate="cvIndexNumber_ServerValidate" ValidationGroup="AddCustomValidatorToGroup"></asp:CustomValidator>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="col-12 col-md-2 mb-1">
                            </div>
                        </div>
                    </div>
                </section>
                <!--section GridView start-->
                <section class="section-gridview mb-3 mb-md-5" runat="server" id="afterChangingTime2">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12 col-md-9" style="overflow-y: scroll; overflow-x: hidden; height: 768px;">
                                <asp:UpdatePanel id="UpdatePanel4" runat="server" UpdateMode="Conditional" ViewStateMode="Enabled">
                                    <ContentTemplate>
                                        <fieldset>
                                            <div class="gridview-left-side">
                                                <asp:Timer ID="Timer2" runat="server" Interval="1000" ontick="Timer2_Tick"></asp:Timer>
                                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AllowPaging="false" AllowSorting="True" ShowHeaderWhenEmpty="True" Width="100%" DataKeyNames="IDDnevniStatusOsobeNaLokaciji,IDOsoba" DataSourceID="dsGridViewEP" Height="100%" PageSize="100" OnRowDataBound="GridView1_RowDataBound">
                                                    <Columns>
                                                        <asp:BoundField DataField="PoslednjaPromena" HeaderText="Poslednja promena" SortExpression="PoslednjaPromena"/>
                                                        <asp:BoundField DataField="TipOsobe" HeaderText="Tip Osobe" SortExpression="TipOsobe"  Visible="false"/>
                                                        <asp:BoundField DataField="Ime" HeaderText="Ime" SortExpression="Ime"/>
                                                        <asp:BoundField DataField="Prezime" HeaderText="Prezime" SortExpression="Prezime" />
                                                        <asp:TemplateField HeaderText="Fotografija" SortExpression="BrojSlike">
                                                            <EditItemTemplate>
                                                                <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("BrojSlike") %>'></asp:TextBox>
                                                            </EditItemTemplate>
                                                            <ItemTemplate>
                                                                <asp:Image ID="Image1" class="img-holder size-gridImage gridImages" runat="server" Height="64px"
                                                                    ImageUrl='<%# System.Configuration.ConfigurationManager.AppSettings["FotografijeFolder"] + Eval("BrojSlike") + ".jpg" %>' 
                                                                    Width="52px"/>
                                                                    <div id="tooltip" style="display: none;">
                                                                    <table>
                                                                    <tr>
                                                                    <%--Image to Show on Hover--%>
                                                                    <td><asp:Image ID="imgUserName" Width="202px" Height="264px" ImageUrl='<%# System.Configuration.ConfigurationManager.AppSettings["FotografijeFolder"] + Eval("BrojSlike") + ".jpg" %>' runat="server" /></td>
                                                                    </tr>
                                                                    </table>
                                                                    </div>
                                                            </ItemTemplate>
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:TemplateField>
                                                        <asp:BoundField DataField="BrojIndeksa" HeaderText="ID" SortExpression="BrojIndeksa"/>
                                                        <asp:BoundField DataField="TipStatusa" HeaderText="Tip statusa" SortExpression="TipStatusa"/>
                                                        <asp:BoundField DataField="Boja" HeaderText="Boja" SortExpression="Boja" Visible="false"/>
                                                        <asp:BoundField DataField="IDOsoba" HeaderText="IDOsoba" SortExpression="IDOsoba" Visible="false"/>
                                                        <asp:BoundField DataField="IDDnevniStatusOsobeNaLokaciji" HeaderText="IDDnevniStatusOsobeNaLokaciji" InsertVisible="False" ReadOnly="True" SortExpression="IDDnevniStatusOsobeNaLokaciji" Visible="false"/>
                                                        <asp:BoundField DataField="DaLiSePrijavaOdnosiNaTrenutniTermin" HeaderText="DaLiSePrijavaOdnosiNaTrenutniTermin" ReadOnly="True" SortExpression="DaLiSePrijavaOdnosiNaTrenutniTermin" Visible="false"/>
                                                    </Columns>
                                                    <FooterStyle BackColor="#333333" BorderColor="#333333" BorderWidth="2px" ForeColor="White" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                    <HeaderStyle ForeColor="White" BackColor="#333333" BorderColor="White" BorderWidth="2px" BorderStyle="Solid" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                    <PagerStyle BackColor="#CCCCCC" BorderColor="#999999" ForeColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                    <RowStyle BorderColor="Black" BorderWidth="1px" Font-Bold="False" Font-Names="Arial" ForeColor="Black" HorizontalAlign="Center" />
                                                </asp:GridView>
                                                <asp:SqlDataSource ID="dsGridViewEP" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="spDnevniStatus" OldValuesParameterFormatString="original_{0}" SelectCommandType="StoredProcedure">
                                                    <SelectParameters>
                                                        <asp:SessionParameter Name="idLokacija" SessionField="predavanjePromena-IDLokacija" Type="Int32" />
                                                        <asp:SessionParameter Name="idTerminPredavanja" SessionField="predavanjePromena-IDTerminPredavanja" Type="Int32" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </div>
                                        </fieldset>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <div class="col-12 col-md-3">
                                <asp:UpdatePanel ID="UpdatePanel3" runat="server"  UpdateMode="Conditional" ViewStateMode="Enabled">
                                    <Triggers>
                                        <asp:AsyncPostBackTrigger ControlID="Timer2" EventName="Tick" />
                                    </Triggers>
                                    <ContentTemplate>
                                        <fieldset>
                                            <div class="gridview-right-side">
                                                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True" ShowHeaderWhenEmpty="True" Width="100%" style="margin-top: 0px" OnRowDataBound="GridView2_RowDataBound" Height="100%" DataSourceID="dsDnevniStatusZbirno">
                                                <Columns>
                                                    <asp:BoundField DataField="TipStatusa" HeaderText="Tip statusa" SortExpression="TipStatusa"/>
                                                    <asp:BoundField DataField="Boja" HeaderText="Boja" SortExpression="Boja" Visible="false"/>
                                                    <asp:BoundField DataField="Ukupno" HeaderText="Ukupno" SortExpression="Ukupno"/>
                                                    <asp:BoundField DataField="DaLiSePrijavaOdnosiNaTrenutniTermin" HeaderText="DaLiSePrijavaOdnosiNaTrenutniTermin" SortExpression="DaLiSePrijavaOdnosiNaTrenutniTermin" Visible="false"/>
                                                    <asp:BoundField DataField="IDTipDnevnogStatusa" HeaderText="IDTipDnevnogStatusa" SortExpression="IDTipDnevnogStatusa" Visible="false"/>
                                                </Columns>
                                                <FooterStyle BackColor="#333333" BorderColor="#333333" BorderWidth="2px" ForeColor="White" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <HeaderStyle ForeColor="White" BackColor="#333333" BorderColor="White" BorderWidth="2px" BorderStyle="Solid" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <PagerStyle BackColor="#CCCCCC" BorderColor="#999999" ForeColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle" />
                                                <RowStyle BorderColor="Black" BorderWidth="1px" Font-Bold="False" Font-Names="Arial" ForeColor="Black" HorizontalAlign="Center" />
                                                </asp:GridView>
                                                <asp:SqlDataSource ID="dsDnevniStatusZbirno" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="spDnevniStatusZbirno" SelectCommandType="StoredProcedure">
                                                    <SelectParameters>
                                                        <asp:SessionParameter Name="idLokacija" SessionField="predavanjePromena-IDLokacija" Type="Int32" />
                                                        <asp:SessionParameter Name="idTerminPredavanja" SessionField="predavanjePromena-IDTerminPredavanja" Type="Int32" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                            </div>
                                        </fieldset>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                        </div> 
                    </div>
                </section><!--section GridView end-->
            </div>
        </main>
    </form>
</body>
</html>
