using System;
using System.Collections.Generic;
using XF.APP.DTO;

namespace XF.APP.ABSTRACTION
{
    public interface IIssueToWorkOrderPageViewModel : IBaseViewModel 
    {
        IssueToWorkOrderDataViewModel IssueToWorkOrderModel { get; set; }
        string SelectedProductionOrderNo { get; set; }
        string SelectedColors { get; set; }
        string SelectedWorkOrderNo { get; set; }
        string SelectedParts { get; set; }
        string SelectedIssueToWorkOrderNo { get; set; }
        string SelectedIssueToLineNo { get; set; }
        string SelectedColorsCode { get; set; }
        string SelectedSizes { get; set; }
        IssueToWorkOrderDataDto IssueToWorkOrderDataDto  { get; set; }

        void OnScreenAppearing();
       
    }
}
