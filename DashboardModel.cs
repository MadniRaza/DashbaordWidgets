using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Linq;

namespace IP.Models
{
    public class DashboardModel
    {
        #region Data Fields
        public string widget_id { get; set; }
        public string widget_desc { get; set; }
        public string widget_count_count { get; set; }
        public string widget_count_fraction { get; set; }
        public string widget_count_bg { get; set; }
        public string widget_count_report_URL { get; set; }
        public string report_URL { get; set; }
        public string report_name { get; set; }
        public string report_target { get; set; }
        public string report_title_short { get; set; }
        public string report_designed_by { get; set; }
        public string report_code { get; set; }
        public string chart_title { get; set; }
        public List<Dictionary<string, object>> lst_widgets { get; set; }
        public List<Employee_Widgets> lst_employee_widgets { get; set; }
        public List<ArrayList> lst_widget_hyperlist { get; set; }
        public List<ArrayList> lst_widget_list { get; set; }
        public List<ArrayList> lst_widget_table { get; set; }
        public List<ArrayList> lst_widget_group_counts { get; set; }
        public string widget_table_column_format { get; set; }
        public int widget_table_cols_count { get; set; }
        public Dictionary<string, object> chart_data { get; set; }

        #endregion
        #region Structures
        public struct Employee_Widgets
        {
            public string WidgetId { get; set; }
            public string WidgetTitle { get; set; }
            public string WidgetType { get; set; }
            public string WidgetMinSize { get; set; }
            public string WidgetMaxSize { get; set; }
            public string WidgetPositionY { get; set; }
            public string WidgetPositionX { get; set; }
            public string WidgetSizeX { get; set; }
            public string WidgetSizeY { get; set; }
        }

        #endregion
        #region Methods
        public void Get_Widget_List()
        {
            cDAL oDAL = new cDAL(cDAL.ConnectionType.CWDB);
            string query = string.Empty;

            query = "SELECT WidgetId, WidgetIcon, WidgetTitle,  WidgetType, WidgetMinSize, WidgetMaxSize ";
            query += "FROM IP_Widgets ";
            query += "WHERE Company = '" + HttpContext.Current.Session["EpicorCompany"].ToString() + "' ";
            query += "AND WidgetStatus = 1 AND InGroup = 0 ";
            query += "ORDER BY WidgetTitle ";
            DataTable dtWidgetsEmployee = oDAL.GetData(query);

            lst_widgets = ConvertDtToList(dtWidgetsEmployee);
        }

        public void Get_Employee_Widgets()
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);
            int employee_id = Convert.ToInt32(HttpContext.Current.Session["EmpId"]);
            string query = "";

            query = "SELECT W.WidgetId, W.WidgetTitle, W.WidgetType, W.WidgetMinSize, W.WidgetMaxSize, WidgetPositionX, WidgetPositionY, WidgetSizeX, WidgetSizeY ";
            query += "FROM IP_Widgets W ";
            query += "INNER JOIN IP_WidgetsEmp E ON E.WidgetId = W.WidgetId ";
            query += "WHERE Company = '" + HttpContext.Current.Session["EpicorCompany"].ToString() + "' ";
            query += "AND W.WidgetStatus = 1 AND E.EmpId = '" + employee_id + "'";
            DataTable dtWidgetsEmployee = portal_db.GetData(query);

            lst_employee_widgets = new List<Employee_Widgets>();
            Employee_Widgets oEmpWidget;
            foreach (DataRow dr in dtWidgetsEmployee.Rows)
            {
                oEmpWidget = new Employee_Widgets();
                oEmpWidget.WidgetId = dr["WidgetId"].ToString();
                oEmpWidget.WidgetTitle = dr["WidgetTitle"].ToString();
                oEmpWidget.WidgetType = dr["WidgetType"].ToString();
                oEmpWidget.WidgetMinSize = dr["WidgetMinSize"].ToString();
                oEmpWidget.WidgetMaxSize = dr["WidgetMaxSize"].ToString();
                oEmpWidget.WidgetPositionY = dr["WidgetPositionY"].ToString();
                oEmpWidget.WidgetPositionX = dr["WidgetPositionX"].ToString();
                oEmpWidget.WidgetSizeX = dr["WidgetSizeX"].ToString();
                oEmpWidget.WidgetSizeY = dr["WidgetSizeY"].ToString();
                lst_employee_widgets.Add(oEmpWidget);
            }
        }

        public void Get_Count_Widget(string widget_id)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);

            string query = string.Empty;

            query = "SELECT WidgetQuery, WidgetDesc, URL, CountType, BackgroundColor FROM IP_Widgets WHERE WidgetId = " + widget_id + " ";
            DataTable dtWidget = portal_db.GetData(query);
            widget_desc = dtWidget.Rows[0]["WidgetDesc"].ToString();
            widget_count_report_URL = dtWidget.Rows[0]["URL"].ToString();
            widget_count_bg = dtWidget.Rows[0]["BackgroundColor"].ToString();
            query = dtWidget.Rows[0]["WidgetQuery"].ToString();
            query = change_query_params(query);

            cDAL widget_db = new cDAL(cDAL.ConnectionType.CWDW);
            //string widget_count_type = dtWidget.Rows[0]["CountType"].ToString();
            //if (widget_count_type.ToLower() == "cost")
            //    widget_count_count = cCommon.SetFormat(widget_db.GetObject(query), cCommon.Format.ForQty).ToString();
            //else
            widget_count_count = cCommon.SetFormat(widget_db.GetObject(query), cCommon.Format.ForQty).ToString();
        }

        public void Get_Group_Counts_Widget(string widget_id)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);

            string query = string.Empty;

            query = "SELECT A.WidgetTitle, A.WidgetQuery, A.URL, A.CountType, A.BackgroundColor  ";
            query += "FROM CWDW.DBO.IP_Widgets A ";
            query += "INNER JOIN IP_WidgetGroupCounts B ON B.Widgetid = A.WidgetId ";
            query += "WHERE B.WidgetGroupId = " + widget_id + " ";
            DataTable dtWidget = portal_db.GetData(query);
            cDAL widget_db = new cDAL(cDAL.ConnectionType.CWDW);
            lst_widget_group_counts = new List<ArrayList>();
            ArrayList count_widget = new ArrayList();

            for (int i = 0; i < dtWidget.Rows.Count; i++)
            {
                count_widget = new ArrayList();
                count_widget.Add(dtWidget.Rows[i]["WidgetTitle"].ToString());
                count_widget.Add(dtWidget.Rows[i]["URL"].ToString());
                count_widget.Add(dtWidget.Rows[i]["CountType"].ToString());
                count_widget.Add(dtWidget.Rows[i]["BackgroundColor"].ToString());

                query = dtWidget.Rows[i]["WidgetQuery"].ToString();
                query = change_query_params(query);

                count_widget.Add(cCommon.SetFormat(widget_db.GetObject(query), cCommon.Format.ForQty).ToString());
                lst_widget_group_counts.Add(count_widget);
            }
        }

        public void Get_List_Widget(string widget_id)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);
            #region SQL
            string query = string.Empty;
            query = "SELECT WidgetQuery FROM IP_Widgets WHERE WidgetId = " + widget_id + " ";
            DataTable dtWidget = portal_db.GetData(query);

            query = dtWidget.Rows[0]["WidgetQuery"].ToString();
            query = change_query_params(query);


            cDAL widget_db = new cDAL(cDAL.ConnectionType.CWDW);
            DataTable dt = widget_db.GetData(query);
            lst_widget_list = cCommon.ConvertDtToArrayList(dt);
            #endregion
        }

        public void Get_HyperList_Widget(string widget_id)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);
            string query = string.Empty;

            query = "SELECT WidgetQuery FROM IP_Widgets WHERE WidgetId = " + widget_id + " ";
            DataTable dtWidget = portal_db.GetData(query);

            query = dtWidget.Rows[0]["WidgetQuery"].ToString();
            query = change_query_params(query);

            cDAL widget_db = new cDAL(cDAL.ConnectionType.CWDW);
            DataTable dt = widget_db.GetData(query);
            lst_widget_hyperlist = cCommon.ConvertDtToArrayList(dt);
        }

        public void Get_Table_Widget(string widget_id)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);

            string query = string.Empty;

            query = "SELECT WidgetQuery, ColumnFormat, ColumnFormat FROM IP_Widgets WHERE WidgetId = " + widget_id + " ";
            DataTable dtWidget = portal_db.GetData(query);
            string table_headers = dtWidget.Rows[0]["ColumnFormat"].ToString();

            query = dtWidget.Rows[0]["WidgetQuery"].ToString();
            query = change_query_params(query);


            widget_table_column_format = dtWidget.Rows[0]["ColumnFormat"].ToString();

            cDAL widget_db = new cDAL(cDAL.ConnectionType.CWDW);
            DataTable dt = widget_db.GetData(query);
            widget_table_cols_count = dt.Columns.Count;
            lst_widget_table = cCommon.ConvertDtToArrayList(dt);
        }

        public void Get_Chart_Widget(string widget_id)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);

            string query = string.Empty;

            query = "SELECT WidgetTitle, WidgetQuery, ColumnFormat, BackgroundColor FROM IP_Widgets WHERE WidgetId = " + widget_id + " ";
            DataTable dtWidget = portal_db.GetData(query);


            query = dtWidget.Rows[0]["WidgetQuery"].ToString();
            query = change_query_params(query);

            cDAL widget_db = new cDAL(cDAL.ConnectionType.CWDW);
            DataTable dt = widget_db.GetData(query);

            chart_data = new Dictionary<string, object>();
            List<Dictionary<string, object>> data_sets = new List<Dictionary<string, object>>();


            string[] x;
            //if (dt.Rows[0]["x"] == string.Empty)
            //    x = new string[dt.Columns.Count - 1];
            //else
            x = new string[dt.Rows.Count];
            string[] headers = dtWidget.Rows[0]["ColumnFormat"].ToString().Split(',');
            string[] back_color = dtWidget.Rows[0]["BackgroundColor"].ToString().Split(',');
            chart_title = dtWidget.Rows[0]["WidgetTitle"].ToString();


            Dictionary<string, object> item;
            string[] y;
            for (int i = 1; i < dt.Columns.Count; i++)
            {
                item = new Dictionary<string, object>();
                item["label"] = headers[i - 1];
                y = new string[dt.Rows.Count];
                //if (dt.Rows[0]["x"] == string.Empty)
                //    x[i - 1] = headers[i - 1];

                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    //if (dt.Rows[j]["x"] != string.Empty)
                    x[j] = dt.Rows[j]["x"].ToString(); //e.g. no group, android parts

                    y[j] = dt.Rows[j][dt.Columns[i].ColumnName].ToString();
                }
                item["data"] = y;
                item["backgroundColor"] = back_color[i - 1]; //background color define;
                data_sets.Add(item);
            }

            chart_data["labels"] = x;
            chart_data["datasets"] = data_sets;
        }

        public void Get_Report_Info(string link)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);
            string query = string.Empty;

            if (!link.Contains("\\\\"))
                link = link.Replace("\\", "\\\\");
            query = "SELECT RptCode as report_code, MnuTitle as report_title, MnuTitleShort as report_title_short,";
            query += "MnuTarget as report_target, DesignedBy as report_designed_by   ";
            query += "FROM IP_Mnu ";
            query += "WHERE MnuHyperlink = '" + link + "' ";
            DataTable dt = portal_db.GetData(query);
            report_code = dt.Rows[0]["report_code"].ToString();
            report_title_short = dt.Rows[0]["report_title_short"].ToString();
            report_target = dt.Rows[0]["report_target"].ToString();
            report_designed_by = dt.Rows[0]["report_designed_by"].ToString();
            report_URL = link;
        }

        public void Save_Employee_Widgets(List<Employee_Widgets> lst)
        {
            cDAL portal_db = new cDAL(cDAL.ConnectionType.CWDB);
            string query = "";
            //INSERTING WIDGETS FOR SINGLE EMPLOYEE
            int employee_id = Convert.ToInt32(HttpContext.Current.Session["EmpId"]);

            query = "DELETE FROM IP_WidgetsEmp WHERE EmpId = " + employee_id + " ";
            query += "AND WidgetId IN (SELECT WidgetId FROM IP_Widgets WHERE Company = '" + HttpContext.Current.Session["EpicorCompany"].ToString() + "')";
            portal_db.AddQuery(query);
            if (lst != null)
            {
                foreach (var row in lst)
                {
                    query = "INSERT INTO IP_WidgetsEmp (EmpID, WidgetId,  WidgetPositionY, WidgetPositionX, ";
                    query += "WidgetSizeX, WidgetSizeY) VALUES (";
                    query += "" + Convert.ToInt32(HttpContext.Current.Session["EmpId"]) + ",";
                    query += "'" + row.WidgetId.Remove(0, 1) + "',";
                    query += "'" + row.WidgetPositionY + "',";
                    query += "'" + row.WidgetPositionX + "',";
                    query += "'" + row.WidgetSizeX + "',";
                    query += "'" + row.WidgetSizeY + "'";
                    query += ")";
                    portal_db.AddQuery(query);
                }
            }
            portal_db.Commit();
        }

        public List<Dictionary<string, object>> ConvertDtToList(DataTable dt)
        {
            List<Dictionary<string, object>>
            lstRows = new List<Dictionary<string, object>>();
            Dictionary<string, object> dictRow = null;

            foreach (DataRow dr in dt.Rows)
            {
                dictRow = new Dictionary<string, object>();
                foreach (DataColumn col in dt.Columns)
                {
                    dictRow.Add(col.ColumnName, dr[col]);
                }
                lstRows.Add(dictRow);
            }
            return lstRows;
        }

        public string change_query_params(string query)
        {
            string epic_company = HttpContext.Current.Session["EpicorCompany"].ToString();
            string epic_plant = HttpContext.Current.Session["EpicorPlant"].ToString();
            int employee_id = Convert.ToInt32(HttpContext.Current.Session["EmpId"]);

            query = query.Replace("@Company", "'" + epic_company + "'");
            query = query.Replace("@Plant", "'" + epic_plant + "'");
            query = query.Replace("@EmpId", "'" + employee_id.ToString() + "'");
            //query = query.Replace("\r\n", "");
            return query;
        }

        #endregion
    }
}