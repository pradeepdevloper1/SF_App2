using XF.APP.ABSTRACTION;
using XF.APP.DTO;
using Newtonsoft.Json;
using System;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks; 

namespace XF.APP.LogService
{
    public class BaseWebService : IBaseWebService
    {
        public HttpClient httpClient { get; set; }
        public RequestDto requestDto { get; set; }
        public ResponseDto responseDto{ get; set; }
        public BaseWebService()
        {
            this.requestDto = new RequestDto();
            this.responseDto = new ResponseDto();
            this.httpClient = new HttpClient();
        }

        public async Task<ResponseDto> SendAsync(ApiRequest apiRequest)
        {
            var uri = new Uri(string.Format(Constants.BaseUrl, apiRequest.Url));
            var dataJson = apiRequest.Data == null ? string.Empty : JsonConvert.SerializeObject(apiRequest.Data);
            var content = new StringContent(dataJson, Encoding.UTF8, "application/json");
            HttpResponseMessage apiResponse = null;
            switch (apiRequest.ApiType)
            {
                case ApiType.POST:
                    apiResponse = await httpClient.PostAsync(uri, content);
                    break;
                case ApiType.DELETE:
                    apiResponse = await httpClient.DeleteAsync(uri);
                    break;
                default:
                    apiResponse = await httpClient.GetAsync(uri);
                    break;
            }
            var apiContent = await apiResponse.Content.ReadAsStringAsync();
            var apiResponseDto = JsonConvert.DeserializeObject<ResponseDto>(apiContent);
            return apiResponseDto;
        }

        public async Task<T> SendAsync<T>(ApiRequest apiRequest)
        {
            var uri = new Uri(string.Format(Constants.BaseUrl, apiRequest.Url));
            var dataJson = apiRequest.Data == null ? string.Empty : JsonConvert.SerializeObject(apiRequest.Data);
            var content = new StringContent(dataJson, Encoding.UTF8, "application/json");
            HttpResponseMessage apiResponse = null;
            switch (apiRequest.ApiType)
            {
                case ApiType.POST:
                    apiResponse = await httpClient.PostAsync(uri, content);
                    break;
                case ApiType.DELETE:
                    apiResponse = await httpClient.DeleteAsync(uri);
                    break;
                default:
                    apiResponse = await httpClient.GetAsync(uri);
                    break;
            }
            var apiContent = await apiResponse.Content.ReadAsStringAsync();
            var apiResponseDto = JsonConvert.DeserializeObject<T>(apiContent);
            return apiResponseDto;
        }
        #region Dispose

        // Track whether Dispose has been called.
        private bool disposed = false;

        // Implement IDisposable.
        // Do not make this method virtual.
        // A derived class should not be able to override this method.
        public void Dispose()
        {
            Dispose(true);
            // This object will be cleaned up by the Dispose method.
            // Therefore, you should call GC.SupressFinalize to
            // take this object off the finalization queue
            // and prevent finalization code for this object
            // from executing a second time.
            GC.SuppressFinalize(this);
        }

        // Dispose(bool disposing) executes in two distinct scenarios.
        // If disposing equals true, the method has been called directly
        // or indirectly by a user's code. Managed and unmanaged resources
        // can be disposed.
        // If disposing equals false, the method has been called by the
        // runtime from inside the finalizer and you should not reference
        // other objects. Only unmanaged resources can be disposed.
        protected virtual void Dispose(bool disposing)
        {
            // Check to see if Dispose has already been called.
            if (!this.disposed)
            {
                // If disposing equals true, dispose all managed
                // and unmanaged resources.
                if (disposing)
                {
                    // Dispose managed resources.
                }

                // Call the appropriate methods to clean up
                // unmanaged resources here.
                // If disposing is false,
                // only the following code is executed.

                // Note disposing has been done.
                disposed = true;
            }
        }

        // Use C# destructor syntax for finalization code.
        // This destructor will run only if the Dispose method
        // does not get called.
        // It gives your base class the opportunity to finalize.
        // Do not provide destructors in types derived from this class.
        ~BaseWebService()
        {
            // Do not re-create Dispose clean-up code here.
            // Calling Dispose(false) is optimal in terms of
            // readability and maintainability.
            Dispose(false);
        }
        #endregion
    }
}
