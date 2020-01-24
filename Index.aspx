<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="Index" %>
<%@ Register TagPrefix="cc1" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Izaberi predavanje-Admin</title>
    <!--#include virtual="~/content/head.inc"-->
    <script src="js/jquery.tooltip.js" type="text/javascript"></script>
    <link href="css/modal-style.css" rel="stylesheet" type="text/css"/>
    <script type="text/javascript">
        function pickdate() {
            $("[id$=txtdate]").datepicker({
                showOn: 'button',
                buttonText: 'Izaberite datum',
                buttonImageOnly: true,                
                buttonImage: "images/calendar.png",
                dayNames: ['Nedelja', 'Ponedeljak', 'Utorak', 'Sreda', 'Četvrtak', 'Petak', 'Subota'],
                dayNamesMin: ['Ned', 'Pon', 'Uto', 'Sre', 'Čet', 'Pet', 'Sub'],
                dateFormat: 'dd.mm.yy',
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
				        <article id="IdForModal" class="navbar-nav ml-auto mt-2 px-lg-5">
                            <asp:Button ID="btnOpenModal" runat="server" CssClass="openModalButton" Text="Promeni lozinku" OnClick="btnOpenModal_Click" />                
                            <br />
                            <div id="divModal" runat="server" class="modalDialog">
                                <div>
                                    <asp:LinkButton ID="lbtnModalClose" runat="server"  CssClass="close" Text="X" OnClick="CloseModal_Click" />
                                    <h2>Promeni lozinku</h2>
                                    <p>Upiši parametre za promenu.</p>
                                    <asp:TextBox ID="txtUsername" runat="server" CssClass="txtmodal mb-2" maxlength="25" TabIndex="1" placeholder="Korisničko ime" ontextchanged="txtUsername_TextChanged"></asp:TextBox>
                                    <br/>
                                    <asp:CustomValidator runat="server" id="cvUsername" controltovalidate="txtUsername" errormessage="" OnServerValidate="cvUsername_ServerValidate" Display="Dynamic" ForeColor="Red" style="font-size:13px;" ValidateEmptyText="true"/>
                                    <br/>
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="txtmodal mb-2" maxlength="15" TabIndex="2" placeholder="Lozinka" ontextchanged="txtPassword_TextChanged"></asp:TextBox>
                                    <br/>
                                    <asp:CustomValidator runat="server" id="cvPassword" controltovalidate="txtPassword" errormessage="" OnServerValidate="cvPassword_ServerValidate" Display="Dynamic" ForeColor="Red" style="font-size:13px;" ValidateEmptyText="true"/>
                                    <br/>
                                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="txtmodal mb-2" maxlength="15" TabIndex="3" placeholder="Nova lozinka"></asp:TextBox>
                                    <br/>
                                    <asp:CustomValidator runat="server" id="cvNewPassword" controltovalidate="txtNewPassword" errormessage="" OnServerValidate="cvNewPassword_ServerValidate" Display="Dynamic" ForeColor="Red" style="font-size:13px;" ValidateEmptyText="true"/>
                                    <br/>
                                    <asp:TextBox ID="txtRepeatNewPassword" runat="server" TextMode="Password" CssClass="txtmodal mb-1" maxlength="15" TabIndex="4" placeholder="Ponovi novu lozinku"></asp:TextBox>
                                    <br/>
                                    <asp:CustomValidator runat="server" id="cvRepeatNewPassword" controltovalidate="txtRepeatNewPassword" errormessage="" OnServerValidate="cvRepeatNewPassword_ServerValidate" Display="Dynamic" ForeColor="Red" style="font-size:13px;" ValidateEmptyText="true"/>
                                    <br/>
                                    <div class="mt-3">
                                        <asp:Button ID="btnChange" runat="server" Text="Promeni" CssClass="btn default" Onclick="btnChange_Click" TabIndex="5"/>
                                        <asp:Button ID="btnClose" runat="server" Text="Zatvori" CssClass="btn default" OnClick="CloseModal_Click" TabIndex="6"/>
                                    </div>
                                </div>
                            </div>
                            <asp:Button ID="btnLogout" runat="server" Text="Odjava" CssClass="btn btn-outline-secondary ml-4 px-md-3 py-md-1" OnClick="btnLogout_Click" OnClientClick="unhook()"/>
				        </article>                        
			        </div><!--header navigation end-->
                </nav>
            </div>
        </header><!--header end-->
        <!--main start-->
        <main>
            <div class="container">
                <section class="mt-3">
                    <div class="row">
                        <!--div new lecture start-->
                        <div class="col-12 col-md-4 mb-1">
                        </div>
                        <div class="col-12 col-md-4 mb-1 text-center">
                            <asp:Button ID="btnInsertNewLecture" runat="server" Text="Upiši novo predavanje" CssClass="btn btn-outline-danger" OnClick="btnInsertNewLecture_Click" OnClientClick="unhook()" TabIndex="1"/>
                        </div>
                        <div class="col-12 col-md-4 mb-1">
                        </div><!--div new lecture end-->
                    </div>
                </section>
                <section id="submit" class="mt-5 mb-3">
                    <asp:UpdatePanel id="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <fieldset>
                                <div class="row">
                                    <div class="col-12 col-md-5 mb-1">
                                        <!--div date start-->
                                        <div class="col-12 mb-1 mb-md-2 text-left">
                                            <asp:Label id="spandate" runat="server" CssClass="submit-span">*</asp:Label><asp:Label id="lbldate" runat="server" CssClass="submit-label ml-2">Datum:</asp:Label>
                                        </div>
                                        <div class="col-12 ">
                                            <div class="row">
                                                <div class="col-12 mb-1">
                                                    <asp:TextBox ID="txtdate" runat="server" CssClass="submit-textbox" maxlength="10" TabIndex="2" AutoPostBack="true"></asp:TextBox>
                                                    <asp:Label id="dateexample" runat="server" CssClass="submit-example ml-2">Primer: 21.09.2010</asp:Label>
                                                </div>
                                                <div class="col-12 mb-1 text-left">
                                                    <asp:CustomValidator ID="cvdate" runat="server" ErrorMessage="" controltovalidate="txtdate" Display="Dynamic" ForeColor="Red" CssClass="submit-customValidator" ValidateEmptyText="true" OnServerValidate="Cvdate_ServerValidate" ValidationGroup="AddCustomValidatorToGroup"></asp:CustomValidator>
                                                </div>
                                            </div>
                                        </div><!--div date end-->
                                    </div>
                                    <div class="col-12 col-md-5 mb-1">
                                        <asp:Button ID="btnSearch" runat="server" Text="Pretraži predavanja" CssClass="btn btn-danger btn-sm mt-md-4" OnClick="btnSearch_Click" OnClientClick="unhook()"/>
                                    </div>
                                </div>
                            </fieldset>
                        </ContentTemplate>
                    </asp:UpdatePanel>           
                </section>
            </div>
                <!--section GridView start-->
                <section class="section-gridview mb-3 mb-md-5">
                    <div class="container container-grid">
                        <asp:UpdatePanel id="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <fieldset>
                                    <div class="table-responsive">
                                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True" ShowHeaderWhenEmpty="True" Width="100%" style="margin-top: 0px" RowStyle-CssClass="rowHover" DataSourceID="dsGridView" DataKeyNames="IDTerminPredavanja" OnRowCommand="GridView1_RowCommand">
                                            <Columns>
                                                <asp:BoundField DataField="NazivLokacije" HeaderText="Naziv lokacije" SortExpression="NazivLokacije"/>
                                                <asp:BoundField DataField="Datum" HeaderText="Datum" SortExpression="Datum" DataFormatString="{0:dd.MM.yyyy}"/>
                                                <asp:BoundField DataField="Pocetak" HeaderText="Početak" SortExpression="Pocetak"/>
                                                <asp:BoundField DataField="Kraj" HeaderText="Kraj" SortExpression="Kraj" />
                                                <asp:BoundField DataField="Predavac" HeaderText="Predavač" SortExpression="Predavac"/>
                                                <asp:BoundField DataField="IDTerminPredavanja" HeaderText="IDTerminPredavanja" SortExpression="IDTerminPredavanja" ReadOnly="True" Visible="false"/>
                                                <asp:TemplateField>                                
                                                    <ItemTemplate>                                    
                                                        <asp:Button ID="btnDetail" runat="server" CommandName="ViewProfile" ToolTip="Prikaži detalje" Text="Detalji" CommandArgument='<%# Container.DisplayIndex %>' CssClass="btn btn-danger my-2 mx-3" onclientclick="unhook()"/>                                 
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                            </Columns>
                                            <FooterStyle BackColor="#333333" BorderColor="#333333" BorderWidth="2px" ForeColor="White" HorizontalAlign="Center" VerticalAlign="Middle" />
                                            <HeaderStyle ForeColor="White" BackColor="#333333" BorderColor="White" BorderWidth="2px" BorderStyle="Solid" HorizontalAlign="Center" VerticalAlign="Middle" />
                                            <PagerStyle BackColor="#CCCCCC" BorderColor="#999999" ForeColor="#333333" HorizontalAlign="Center" VerticalAlign="Middle" />
                                            <RowStyle BackColor="Silver" BorderColor="Black" BorderWidth="1px" Font-Bold="False" Font-Names="Arial" ForeColor="Black" HorizontalAlign="Center" />
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="dsGridView" runat="server" ConnectionString="<%$ ConnectionStrings:BioConnectionString %>" SelectCommand="SELECT NazivLokacije, Datum, Pocetak, Kraj, Predavac, IDTerminPredavanja FROM vPregledTerminaAdmin WHERE (Datum = @datum) ORDER BY NazivLokacije, Pocetak">
                                            <SelectParameters>
                                                <asp:SessionParameter Name="datum" SessionField="IzabraniDatum-Predavanja" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </div>
                                </fieldset>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </section><!--section GridView end-->


        </main><!--main end-->
    </form>
</body>
</html>
