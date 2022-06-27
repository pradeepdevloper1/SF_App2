using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using XF.APP.ABSTRACTION;
using XF.APP.DTO;

namespace XF.BASE.Pages
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class IssueToWorkOrderPage : BasePage
    {
        public IIssueToWorkOrderPageViewModel Context { get; set; }
        private ITransactionService transactionService;
        public IssueToWorkOrderPage()
        {
            InitializeComponent();
            BindingContext = null;

        }

        protected override void OnAppearing()
        {
            base.OnAppearing();

            if (BindingContext == null)
            {
                Context = DependencyService.Get<IIssueToWorkOrderPageViewModel>();

                BindingContext = Context;
            }
            Context.OnScreenAppearing();
        }

      

        void Entry_TextChanged(System.Object sender, Xamarin.Forms.TextChangedEventArgs e)
        {
           var abc = Context.IssueToWorkOrderDataDto.data.Sum(x => x.issueColorQty);
            totalqty.Text = abc.ToString();
        }



    }


}

