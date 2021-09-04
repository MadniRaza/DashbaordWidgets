using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using IP.Models;
namespace IP.Controllers
{
    public class DashboardController : Controller
    {
        
        public ActionResult Index()
        {
            return View();
        }

        [HttpGet]
        public JsonResult GetWidgetList()
        {
            Dictionary<string, object> response = new Dictionary<string, object>();
            DashboardModel oModel = new DashboardModel();
            oModel.Get_Widget_List();
            response["lst_widgets"] = oModel.lst_widgets;
            response["IsValid"] = true;
            return Json(response, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        public JsonResult LoadWidget(string widget_id,string widget_type)
        {
            DashboardModel oModel = new DashboardModel();
            Dictionary<string, object> response = new Dictionary<string, object>();
            if (widget_type.ToLower() == "count")
            {
                oModel.Get_Count_Widget(widget_id);
                response["widget_desc"] = oModel.widget_desc;
                response["widget_count_count"] = oModel.widget_count_count;
                response["widget_count_bg"] = oModel.widget_count_bg;
                response["widget_count_fraction"] = oModel.widget_count_fraction;
                response["widget_count_report_URL"] = oModel.widget_count_report_URL;
            }
            else if(widget_type.ToLower() == "table")
            {
                oModel.Get_Table_Widget(widget_id);
                response["lst_widget_table"] = oModel.lst_widget_table;
                response["widget_table_column_format"] = oModel.widget_table_column_format;
                response["widget_table_cols_count"] = oModel.widget_table_cols_count;
                
            }
            else if (widget_type.ToLower() == "list")
            {
                oModel.Get_List_Widget(widget_id);
                response["lst_widget_list"] = oModel.lst_widget_list;
            }
            else if (widget_type.ToLower() == "hyperlist")
            {
                oModel.Get_HyperList_Widget(widget_id);
                response["lst_widget_hyperlist"] = oModel.lst_widget_hyperlist;
            }
            else if (widget_type.ToLower() == "chart")
            {
                oModel.Get_Chart_Widget(widget_id);
                response["chart_data"] = oModel.chart_data;
                response["chart_title"] = oModel.chart_title;
            }
            else if(widget_type.ToLower() == "count_group")
            {
                oModel.Get_Group_Counts_Widget(widget_id);
                response["lst_widget_group_counts"] = oModel.lst_widget_group_counts;
            }
            //else if (widget_type.ToLower() == "count_group_1")
            //{
            //    oModel.Get_Group_Counts_Widget(widget_id);
            //    response["lst_widget_group_counts"] = oModel.lst_widget_group_counts;
            //}
            //else if (widget_type.ToLower() == "count_group_2")
            //{
            //    oModel.Get_Group_Counts_Widget(widget_id);
            //    response["lst_widget_group_counts"] = oModel.lst_widget_group_counts;
            //}
            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public JsonResult SaveEmployeeWidgets(List<DashboardModel.Employee_Widgets> lst)
        {
            Dictionary<string, object> response = new Dictionary<string, object>();
            DashboardModel oModel = new DashboardModel();
            oModel.Save_Employee_Widgets(lst);
            return Json(response, JsonRequestBehavior.AllowGet);
        }

        public JsonResult GetEmployeeWidgets()
        {
            Dictionary<string, object> response = new Dictionary<string, object>();
            DashboardModel oModel = new DashboardModel();

            oModel.Get_Employee_Widgets();

            response["lstWidgetsEmployee"] = oModel.lst_employee_widgets;
            response["IsValid"] = true;
            return Json(response, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetURLInfo(string link)
        {
            DashboardModel oModel = new DashboardModel();
            Dictionary<string, object> response = new Dictionary<string, object>();
            oModel.Get_Report_Info(link);
            response["URL"] = oModel.report_URL;
            response["code"] = oModel.report_code;
            response["title_short"] = oModel.report_title_short;
            response["designed_by"] = oModel.report_designed_by;
            response["target"] = oModel.report_target;

            return Json(response, JsonRequestBehavior.AllowGet);
        }
    }
}