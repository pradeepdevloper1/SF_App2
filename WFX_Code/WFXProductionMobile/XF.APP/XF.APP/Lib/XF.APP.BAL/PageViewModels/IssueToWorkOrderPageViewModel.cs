using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Input;
using Acr.UserDialogs;
using XF.APP.ABSTRACTION;
using XF.APP.DTO;
using Xamarin.Forms;
using System.Data;
using Xamarin.Essentials;

namespace XF.APP.BAL
{
    public class IssueToWorkOrderPageViewModel : BaseViewModel, IIssueToWorkOrderPageViewModel
    {
        public ICommand CloseCommand1 { get; set; }
        public ICommand DropDownCommand { set; get; }
        public ICommand IssueQtyCommand { set; get; }

        private ITransactionService transactionService;

        IssueToWorkOrderDataViewModel issueToWorkOrderModel;
        public IssueToWorkOrderDataViewModel IssueToWorkOrderModel
        {
            get { return issueToWorkOrderModel; }
            set { SetProperty(ref issueToWorkOrderModel, value); }
        }

        string selectedProductionOrderNo;
        public string SelectedProductionOrderNo
        {
            get { return selectedProductionOrderNo; }
            set { SetProperty(ref selectedProductionOrderNo, value); }
        }

        string selectedWorkOrderNo;
        public string SelectedWorkOrderNo
        {
            get { return selectedWorkOrderNo; }
            set { SetProperty(ref selectedWorkOrderNo, value); }
        }

        string selectedParts;
        public string SelectedParts
        {
            get { return selectedParts; }
            set { SetProperty(ref selectedParts, value); }
        }

        string selectedColors;
        public string SelectedColors
        {
            get { return selectedColors; }
            set { SetProperty(ref selectedColors, value); }
        }

        string selectedColorsCode;
        public string SelectedColorsCode
        {
            get { return selectedColorsCode; }
            set { SetProperty(ref selectedColorsCode, value); }
        }

        string selectedIssueToWorkOrderNo;
        public string SelectedIssueToWorkOrderNo
        {
            get { return selectedIssueToWorkOrderNo; }
            set { SetProperty(ref selectedIssueToWorkOrderNo, value); }
        }

        string selectedIssueToLineNo;
        public string SelectedIssueToLineNo
        {
            get { return selectedIssueToLineNo; }
            set { SetProperty(ref selectedIssueToLineNo, value); }
        }
        string selectedSizes;
        public string SelectedSizes
        {
            get { return selectedSizes; }
            set { SetProperty(ref selectedSizes, value); }
        }
        IssueToWorkOrderDataDto issueToWorkOrderDataDto;
        public IssueToWorkOrderDataDto IssueToWorkOrderDataDto
        {
            get { return issueToWorkOrderDataDto; }
            set { SetProperty(ref issueToWorkOrderDataDto, value); }
        }


        public IssueToWorkOrderPageViewModel()
        {
            InitilizeData();
        }

        public void InitilizeData()
        {
            CloseCommand1 = new BaseCommand((object obj) => CloseCommand1Clicked());
            DropDownCommand = new BaseCommand((object obj) => DropDownCommandClickedAsync(obj));
            IssueQtyCommand = new BaseCommand((object obj) => IssueQtyCommandClickedAsync());
            transactionService = ServiceLocator.Resolve<ITransactionService>();
            SelectedParts = string.Empty;
            selectedColors = string.Empty;
            SelectedProductionOrderNo = string.Empty;
            SelectedWorkOrderNo = string.Empty;
            SelectedIssueToWorkOrderNo = string.Empty;
            SelectedIssueToLineNo = string.Empty;
            SelectedColorsCode = string.Empty;

        }



        private async Task DropDownCommandClickedAsync(object sender)
        {
            var existRecords = await transactionService.GetAllPoAsync();

            string selectedValue;

            switch (sender)
            {

                case "ProductionOrderNo":
                    IssueToWorkOrderDataDto = new IssueToWorkOrderDataDto();
                    SelectedParts = string.Empty;
                    selectedColors = string.Empty;
                    SelectedWorkOrderNo = string.Empty;
                    SelectedIssueToWorkOrderNo = string.Empty;
                    SelectedIssueToLineNo = string.Empty;
                    SelectedColorsCode = string.Empty;
                    selectedValue = string.Empty;
                    SelectedProductionOrderNo = string.Empty;
                    issueToWorkOrderModel.Colors = new Dictionary<string, string>();
                    issueToWorkOrderModel.SelectedColors = null;
                    issueToWorkOrderModel.SelectedColorsCode = null;
                    issueToWorkOrderModel.IssueToWorkOrderNo = null;
                    issueToWorkOrderModel.IssueToLineNo = null;
                    //ProcessDatadto.data = new List<ProcessData>();

                    selectedValue = await UserDialogs.Instance.ActionSheetAsync($"Choose {sender}", "Cancel", null, null, issueToWorkOrderModel.ProductionOrderNo.ToArray());
                    SelectedProductionOrderNo = selectedValue.Equals("Cancel") ? SelectedProductionOrderNo : selectedValue;
                    break;

                case "WorkOrderNo":
                    var workOrderNoList = existRecords.Where(x => x.SoNo == SelectedProductionOrderNo && x.ProcessCode != null).Select(x => x.PoNo).Distinct().ToList();
                    selectedValue = await UserDialogs.Instance.ActionSheetAsync($"Choose {sender}", "Cancel", null, null, workOrderNoList.ToArray());
                    SelectedWorkOrderNo = selectedValue.Equals("Cancel") ? SelectedWorkOrderNo : selectedValue;
                    var userService = ServiceLocator.Resolve<IUserWebService>();
                    string processCode = existRecords.Where(x => x.PoNo == selectedWorkOrderNo).Select(x => x.ProcessCode).FirstOrDefault();
                    var result = await userService.GetIssueToWOData<PONoDtoList>(new PostQCInputDto()
                    {
                        PONo = selectedWorkOrderNo,
                        SONo = SelectedProductionOrderNo,
                        ProcessCode = processCode
                    });
                    issueToWorkOrderModel.IssueToWorkOrderNo = result.data.Select(x => x.PONo).ToList();
                    issueToWorkOrderModel.IssueToLineNo = result.data.Select(x => x.Line).ToList();
                    break;

                case "Parts":
                    var PartsList = existRecords.Where(x => x.PoNo == selectedWorkOrderNo).Select(x => x.Part).Distinct().ToList();
                    selectedValue = await UserDialogs.Instance.ActionSheetAsync($"Choose {sender}", "Cancel", null, null, PartsList.ToArray());
                    SelectedParts = selectedValue.Equals("Cancel") ? SelectedParts : selectedValue;
                    break;

                case "Colors":

                    var Colours = existRecords.Where(x => x.PoNo == selectedWorkOrderNo).Select(x => new { x.Color, x.Hexcode, x.SizeList }).Distinct().ToList();
                    issueToWorkOrderModel.Colors = new Dictionary<string, string>();
                    issueToWorkOrderModel.Colors.Add("All", "-1");
                    foreach (var c in Colours)
                        if (!issueToWorkOrderModel.Colors.ContainsKey(c.Color))
                            issueToWorkOrderModel.Colors.Add(c.Color, Color.FromHex(c.Hexcode).ToHex());
                    //var ColorsList = existRecords.Where(x => x.PoNo == selectedWorkOrderNo).Select(x => x.Color).Distinct().ToList();
                    //selectedValue = ListBoxOptions.Items.Cast<CheckBox>().Where(x => x.IsChecked == true).Select(x => x.Content).ToList();

                    selectedValue = await UserDialogs.Instance.ActionSheetAsync($"Choose {sender}", "Cancel", null, null, issueToWorkOrderModel.Colors.Keys.ToArray());
                    SelectedColors = selectedValue.Equals("Cancel") ? SelectedColors : selectedValue;
                    SelectedColorsCode = selectedValue.Equals("Cancel") ? SelectedColorsCode : issueToWorkOrderModel.Colors.FirstOrDefault(x => x.Key == selectedValue).Value;
                    //SelectedSizes = Colours.Where(x => x.Color == SelectedColors).Select(x=> x.SizeList).FirstOrDefault();
                    BindGridData();
                    break;

                case "IssueToWorkOrderNo":
                    selectedValue = await UserDialogs.Instance.ActionSheetAsync($"Choose {sender}", "Cancel", null, null, issueToWorkOrderModel.IssueToWorkOrderNo.ToArray());
                    SelectedIssueToWorkOrderNo = selectedValue.Equals("Cancel") ? SelectedIssueToWorkOrderNo : selectedValue;
                    break;

                case "IssuetToLineNo":
                    selectedValue = await UserDialogs.Instance.ActionSheetAsync($"Choose {sender}", "Cancel", null, null, issueToWorkOrderModel.IssueToLineNo.ToArray());
                    SelectedIssueToLineNo = selectedValue.Equals("Cancel") ? SelectedIssueToLineNo : selectedValue;
                    break;
            }

        }

        private async Task IssueQtyCommandClickedAsync()
        {
            if (Validate())
            {
                bool isConfirmed = await UserDialogs.Instance.ConfirmAsync("Are you sure you want to Submit?", "Confirmation", "Yes", "No");

                if (isConfirmed)
                {
                    string colorName = "";
                    var dataset = IssueToWorkOrderDataDto.data;
                    List<OrderIssue> orderIssueData = new List<OrderIssue>();
                    foreach (var onerow in dataset)
                    {
                        if (onerow.issueColorQty > 0)
                        {
                            if (onerow.color != "")
                            {
                                colorName = onerow.color;
                            }
                            OrderIssue obj = new OrderIssue();
                            obj.SONo = SelectedProductionOrderNo;
                            obj.PONo = SelectedWorkOrderNo;
                            obj.Part = selectedParts;
                            obj.Color = colorName;
                            obj.Size = onerow.size;
                            obj.Qty = onerow.issueColorQty;
                            obj.TabletID = Preferences.Get("TabletID", string.Empty);
                            obj.WFXColorCode = onerow.wfxColorCode;
                            obj.WFXColorName = onerow.wfxColorName;
                            obj.StyleRef = onerow.StyleRef;
                            obj.Line = Preferences.Get("LINE_ID", string.Empty);
                            obj.ToPONo = SelectedIssueToWorkOrderNo;
                            obj.ToLine = SelectedIssueToLineNo;
                            orderIssueData.Add(obj);
                        }

                    }
                    if (orderIssueData.Count() > 0)
                    {

                        var userService = ServiceLocator.Resolve<IUserWebService>();
                        var result = await userService.PostOrderIssue<BaseResponseDto>(orderIssueData);

                        if (result.status == System.Net.HttpStatusCode.OK)
                        {
                            MoveToDashBoard();
                        }
                        else
                        {
                            UserDialogs.Instance.Alert("Not able to submit data, Please try again later.");
                        }
                    }
                    else
                    {
                        UserDialogs.Instance.Alert("Please check the Issue Color Qty!");
                    }

                }
            }

        }
        private bool Validate()
        {
            bool isValid = true;
            if (selectedProductionOrderNo == "")
            {
                UserDialogs.Instance.Alert("Please select Production order number");
                isValid = false;
            }
            if (SelectedWorkOrderNo == "" && isValid == true)
            {
                UserDialogs.Instance.Alert("Please select WorkOrderNo");
                isValid = false;
            }
            if (SelectedParts == "" && isValid == true)
            {
                UserDialogs.Instance.Alert("Please select Parts");
                isValid = false;
            }
            if (selectedColors == "" && isValid == true)
            {
                UserDialogs.Instance.Alert("Please select Colors");
                isValid = false;
            }
            if (SelectedIssueToWorkOrderNo == "" && isValid == true)
            {
                UserDialogs.Instance.Alert("Please select Issue to Work Order No.");
                isValid = false;
            }
            if (SelectedIssueToLineNo == "" && isValid == true)
            {
                UserDialogs.Instance.Alert("Please select Issue to Line No.");
                isValid = false;
            }
            return isValid;
        }

        protected void MoveToDashBoard()
        {

            SelectedParts = string.Empty;
            selectedColors = string.Empty;
            SelectedProductionOrderNo = string.Empty;
            SelectedWorkOrderNo = string.Empty;
            SelectedIssueToWorkOrderNo = string.Empty;
            SelectedIssueToLineNo = string.Empty;
            SelectedColorsCode = string.Empty;
            IssueToWorkOrderDataDto.data.Clear();
            SalesOrdersPageViewModel.ChangeToSoView = true;
            NativeService.NavigationService.SetRootPage("MasterPage");
        }

        public async void BindGridData()
        {
            var userService = ServiceLocator.Resolve<IUserWebService>();
            var result = await userService.GetIssueToNextProcessData<IssueToWorkOrderDataDto>(new PostQCInputDto()
            {
                PONo = selectedWorkOrderNo,
                SONo = SelectedProductionOrderNo,
                Part = selectedParts,
                Color = SelectedColors

            });
            IssueToWorkOrderDataDto = result;
            // ProcessDatadto.Totalqty = result.data.Sum(x => x.issueColorQty);
        }

        public void OnScreenAppearing()
        {
            Task.Run(async () => { await FillSO(); });
            issueToWorkOrderModel = new IssueToWorkOrderDataViewModel();
            issueToWorkOrderModel.Colors = new Dictionary<string, string>();
            IssueToWorkOrderDataDto = new IssueToWorkOrderDataDto();

        }
        private void CloseCommand1Clicked()
        {
            SelectedParts = string.Empty;
            selectedColors = string.Empty;
            SelectedProductionOrderNo = string.Empty;
            SelectedWorkOrderNo = string.Empty;
            SelectedIssueToWorkOrderNo = string.Empty;
            SelectedIssueToLineNo = string.Empty;
            SelectedColorsCode = string.Empty;
            IssueToWorkOrderDataDto.data = null;
            NativeService.NavigationService.GoBack();
        }
        public async Task FillSO()
        {
            if (IsBusy || InternetConnectivity.IsNetworkNotAvailable())
                return;

            IsBusy = true;

            try
            {
                UserDialogs.Instance.ShowLoading(LoadingText);
                var existRecords = await transactionService.GetAllPoAsync();
                if (existRecords != null)
                {
                    int FactoryID = Preferences.Get("FACTORY_ID", 0);
                    issueToWorkOrderModel.ProductionOrderNo = existRecords.Where(x => x.FactoryID == FactoryID).Select(x => x.SoNo).Distinct().ToList();
                    //var POList = existRecords.Where();
                    //var POList1 = existRecords.Where(x => x.);
                    //var data = existRecords.GroupBy( x=> new { SoNo = x.SoNo, PoNo = x.PoNo }).Select(g => new {PoNO = g.Key.PoNo,SoNo =  g.Key.SoNo }).ToList();
                    //var poCountData = data.GroupBy(x => new { SoNo = x.SoNo }).Select(g => new { poCount = g.Count(), SoNo = g.Key.SoNo }).ToList();
                    //issueToWorkOrderModel.ProductionOrderNo = poCountData.Where(x => x.poCount>1).Select(x => x.SoNo).ToList();
                }
                UserDialogs.Instance.HideLoading();
            }
            catch (Exception ex)
            {

            }
            finally
            {
                IsBusy = false;
            }


        }
    }
}




