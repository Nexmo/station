using Nexmo.Api;
using System;
using System.Web.Mvc;

namespace NexmoDotNetQuickStarts.Controllers
{
    public class SearchController : Controller
    {
        [HttpGet]
        public ActionResult Index()
        {
            return View();
        }
        // GET: /<controller>/
        [HttpGet]
        public ActionResult SearchMessage()
        {
            return View();
        }
        [HttpPost]
        public ActionResult SearchMessage(string messageID)
        {
            var message = Search.GetMessage(messageID);
            if (message.messageId != null)
            {
                ViewData.Add("message", message);
            }
            else
            {
                bool notFound = true;
                ViewData.Add("notFound", notFound);
            }
            return View();
        }
        [HttpGet]
        public ActionResult SearchRejection()
        {
            return View();
        }
        [HttpPost]
        public ActionResult SearchRejection(string messageID, string number, DateTime rejectionDate)
        {

            string date = rejectionDate.Year + "-" + rejectionDate.Month + "-" + rejectionDate.Day;

            var msgs = Search.GetRejections(new Search.SearchRequest
            {
                date = date,
                to = number
            });
            if (msgs.items != null)
            {
                ViewData.Add("items", msgs.items);
            }
            else
            {
                bool notFound = true;
                ViewData.Add("notFound", notFound);
            }
            return View();
        }
    }
}