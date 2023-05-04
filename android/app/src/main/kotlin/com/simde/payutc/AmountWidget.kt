package com.simde.payutc

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class AmountWidget : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.mon_solde_widget).apply {

                // Open App on Widget Click
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context, MainActivity::class.java
                )
                setOnClickPendingIntent(R.id.mon_solde_root, pendingIntent)

                val amount = widgetData.getInt("payutc_amount_value", 0)
                //value is 0000 diplay as 00.00€
                val text = "%.${2}f€".format(amount/(100F))
                setTextViewText(R.id.mon_solde_text, text.replace(',','.'))
                val date = widgetData.getString("payutc_reload_time", "Clique pour mettre à jour")
                setTextViewText(R.id.last_update_text,date)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}