using Nexmo.Api;
using Nexmo.Api.Voice;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NexmoDotNetQuickStarts.Controllers
{
    public class VoiceController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
        [HttpGet]
        public ActionResult MakeCall()
        {
            return View();
        }
        [HttpPost]
        public ActionResult MakeCall(string to)
        {

            var results = Call.Do(new Call.CallCommand
            {
                to = new[]
                {
                    new Call.Endpoint {
                        type = "phone",
                        number = to
                    }
                },
                from = new Call.Endpoint
                {
                    type = "phone",
                    number = Configuration.Instance.Settings["appsettings:NEXMO_FROM_NUMBER"]
                },
                answer_url = new[]
                {
                    "https://nexmo-community.github.io/ncco-examples/first_call_talk.json"
                }
            });
            var result = new HttpStatusCodeResult(200);

            return RedirectToAction("Index", "Voice");
        }

        [HttpGet]
        public ActionResult CallList()
        {
            var results = Call.List()._embedded.calls;
            for (int i = 0; i < results.Count; i++)
            {
                Debug.WriteLine(results[i].conversation_uuid);
            }
            ViewData.Add("results", results);
            ViewData.Add("count", results.Count);
            return View();
        }

        [HttpGet]
        public ActionResult GetCall()
        {
            return View();
        }
        [HttpPost]
        public ActionResult GetCall(string id)
        {
            var call = Call.Get(id);
            ViewData.Add("call", call);
            return View();
        }
    }
}