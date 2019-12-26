<%@ Page Language="C#" AutoEventWireup="true" CodeFile="novoPredavanje.aspx.cs" Inherits="novoPredavanje" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit"%>

<!DOCTYPE html">

<html>
<head runat="server">
    <title>Novo predavanje-Admin</title>
    <!--#include virtual="~/content/head.inc"-->
    <script src="js/jquery.tooltip.js" type="text/javascript"></script>
    <script type="text/javascript">
        function pickdate() {
            $("[id$=txtdate]").datepicker({
                showOn: 'button',
                buttonText: 'Izaberite datum',
                buttonImageOnly: true,                
                buttonImage: "images/calendar.png",
                dayNames: ['Nedelja', 'Ponedeljak', 'Utorak', 'Sreda', 'Četvrtak', 'Petak', 'Subota'],
                dayNamesMin: ['Ned', 'Pon', 'Uto', 'Sre', 'Čet', 'Pet', 'Sub'],
                dateFormat: 'yy-mm-dd',
                monthNames: ['Januar', 'Februar', 'Mart', 'April', 'Maj', 'Jun', 'Jul', 'Avgust', 'Septembar', 'Oktobar', 'Novembar', 'Decembar'],
                monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'Maj', 'Jun', 'Jul', 'Avg', 'Sep', 'Okt', 'Nov', 'Dec'],
                firstDay: 1,
                constrainInput: true,
                changeMonth: true,
                changeYear: true,
                yearRange: '1900:2100',
                showButtonPanel: false,
                closeText: "Zatvori",
                beforeShow: function () { try { FixIE6HideSelects(); } catch (err) { } },
                onClose: function () { try { FixIE6ShowSelects(); } catch (err) { } }
            });
            $(".ui-datepicker-trigger").mouseover(function () {
                $(this).css('cursor', 'pointer');
            });
            $(".ui-datepicker-trigger").css("margin-bottom", "3px");
            $(".ui-datepicker-trigger").css("margin-left", "3px");
        };
        function DisableCalendar() {
            $("[id$=txtdate]").datepicker('disable');
            return false;
        }
        function EnableCalendar() {
            $("[id$=txtdate]").datepicker('enable');
            return false;
        }
    </script>
</head>
<body class="login-bg">
    <form id="form1" runat="server">
        <!--AJAX ToolkitScriptManager-->
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></cc1:ToolkitScriptManager>
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
            <div class="container">
                <section id="submit" class="mt-5 mb-5">
                    <asp:UpdatePanel id="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <fieldset>
                                <div class="row">
                                    <div class="col-12 col-md-6 mb-3 mb-md-0">
                                        <!--div date start-->
                                        <div class="col-12 mb-1 mb-md-2 text-left">
                                            <asp:Label id="spandate" runat="server" CssClass="submit-span">*</asp:Label><asp:Label id="lbldate" runat="server" CssClass="submit-label ml-2">Datum:</asp:Label>
                                        </div>
                                        <div class="col-12 ">
                                            <div class="row">
                                                <div class="col-12 mb-1">
                                                    <asp:TextBox ID="txtdate" runat="server" CssClass="submit-textbox" maxlength="10" TabIndex="1" AutoPostBack="true"></asp:TextBox>
                                                    <asp:Label id="dateexample" runat="server" CssClass="submit-example ml-2">Primer: 2010-09-21</asp:Label>
                                                </div>
                                                <div class="col-12 mb-1 text-left">
                                                    <asp:CustomValidator ID="cvdate" runat="server" ErrorMessage="" controltovalidate="txtdate" Display="Dynamic" ForeColor="Red" CssClass="submit-customValidator" ValidateEmptyText="true" OnServerValidate="Cvdate_ServerValidate" ValidationGroup="AddCustomValidatorToGroup"></asp:CustomValidator>
                                                </div>
                                            </div>
                                        </div><!--div date end-->
                                        <!--div ddlLocation start-->
                                        <div class="col-12 col-lg-2 mb-1 mb-md-4 mt-md-4">
                                            <asp:Label id="spanLocation" runat="server" CssClass="submit-span">*</asp:Label><asp:Label id="lblLocation" runat="server" CssClass="submit-label ml-2">Lokacija:</asp:Label> 
                                        </div>
                                        <div class="col-12 col-lg-10">
                                            <div class="row">
                                                <div class="col-12 mb-1 pr-5">
                                                    <asp:DropDownList ID="ddlLocation" runat="server" AppendDataBoundItems="True" AutoPostBack="True" CssClass="submit-dropdownlist" OnSelectedIndexChanged="ddlLocation_SelectedIndexChanged" TabIndex="2" DataSourceID="dsLocation" DataTextField="NazivLokacije" DataValueField="IDLokacija">
                                                    <asp:ListItem Selected="True" Value="0">--Izaberite--</asp:ListItem>
                                                    </asp:DropDownList>                   
                                                    <asp:SqlDataSource ID="dsLocation" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT IDLokacija, NazivLokacije FROM Lokacija"></asp:SqlDataSource>
                                                </div>
                                                <div class="col-12 mb-1">
                                                    <asp:CustomValidator runat="server" id="cvLocation" controltovalidate="ddlLocation" errormessage="" OnServerValidate="CvLocation_ServerValidate" CssClass="submit-customValidator" Display="Dynamic" ForeColor="Red" ValidateEmptyText="true" ValidationGroup="AddCustomValidatorToGroup"/>
                                                </div>
                                            </div>
                                        </div><!--div ddlLocation end-->
                                    </div>
                                </div>
                            </fieldset>
                        </ContentTemplate>
                    </asp:UpdatePanel>           
                </section>
                <!--section GridView start-->
                <section class="section-gridview mb-3 mb-md-5 mt-3">
                    <asp:UpdatePanel id="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <fieldset>
                                <div class="table-responsive">
                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" AllowPaging="True" AllowSorting="True" ShowHeaderWhenEmpty="True" Width="100%" style="margin-top: 0px" RowStyle-CssClass="rowHover" DataSourceID="dsGridView" DataKeyNames="IDTerminPredavanja" OnRowCommand="GridView1_RowCommand" TabIndex="3" PageSize="100">
                                        <Columns>
                                            <asp:BoundField DataField="Pocetak" HeaderText="Pocetak" SortExpression="Pocetak"/>
                                            <asp:BoundField DataField="Kraj" HeaderText="Kraj" SortExpression="Kraj"/>
                                            <asp:BoundField DataField="KorisnickiNalog" HeaderText="Korisnicki nalog" SortExpression="KorisnickiNalog"/>
                                            <asp:CheckBoxField DataField="NijeOdjavljenoKrozProgram" HeaderText="Nije odjavljeno kroz program" SortExpression="NijeOdjavljenoKrozProgram" />
                                            <asp:BoundField DataField="IDTerminPredavanja" HeaderText="IDTerminPredavanja" SortExpression="IDTerminPredavanja" InsertVisible="False" ReadOnly="True" Visible="false"/>
                                        </Columns>
                                        <FooterStyle BackColor="#333333" BorderColor="#333333" BorderWidth="2px" ForeColor="White" HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <HeaderStyle ForeColor="White" BackColor="#333333" BorderColor="White" BorderWidth="2px" BorderStyle="Solid" HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <PagerStyle BackColor="#CCCCCC" BorderColor="#999999" ForeColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle" />
                                        <RowStyle BackColor="Silver" BorderColor="Black" BorderWidth="1px" Font-Bold="False" Font-Names="Arial" ForeColor="Black" HorizontalAlign="Center" />
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="dsGridView" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT TOP (100) PERCENT TerminPredavanja.Pocetak, TerminPredavanja.Kraj, KorisnickiNalog.KorisnickiNalog, TerminPredavanja.NijeOdjavljenoKrozProgram, TerminPredavanja.IDTerminPredavanja FROM TerminPredavanja INNER JOIN KorisnickiNalog ON TerminPredavanja.IDOsobaPredavac = KorisnickiNalog.ID WHERE (TerminPredavanja.Datum = @datum) AND (TerminPredavanja.IDLokacija = @idLokacija) ORDER BY TerminPredavanja.Pocetak">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="datum" SessionField="NovoPredavanje-IzabraniDatum" />
                                            <asp:SessionParameter DefaultValue="" Name="idLokacija" SessionField="NovoPredavanje-idLokacija" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                            </fieldset>
                        </ContentTemplate>
                    </asp:UpdatePanel>  
                    <section class="text-center mt-5">
                        <asp:Button ID="btnSelectItems" runat="server" Text="Izaberi predmete" CssClass="btn btn-danger mt-md-4" OnClick="btnSelectItems_Click" OnClientClick="unhook()" TabIndex="4"/>
                    </section>
                </section><!--section GridView end-->
            </div>
        </main><!--main end-->
    </form>
</body>
</html>
