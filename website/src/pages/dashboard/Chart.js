import React from "react";
import { useTheme } from "@material-ui/core/styles";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Label,
  ResponsiveContainer,
} from "recharts";
import Title from "./Title";
import { Order } from "../../Models";

export default function Chart(props) {
  const theme = useTheme();
  console.log("props.data", props.data);
  // Generate Sales Data
  var orders;
  orders = props.data.orders.map((orderObject) => {
    return new Order(orderObject);
  });
  for (var i in orders) {
    console.log("order", orders[i]);
  }

  const createData = (order) => {
    console.log("order", order);
    const time = order.dateTime;
    console.log("time", time);
    const amount = order.cost;
    return { time, amount };
  };
  const dataFormatted = orders.map((order) => createData(order));
  console.log("dataFormatted", dataFormatted);
  return (
    <React.Fragment>
      <Title>Today</Title>
      <ResponsiveContainer>
        <LineChart
          data={dataFormatted}
          margin={{
            top: 16,
            right: 16,
            bottom: 0,
            left: 24,
          }}
        >
          <XAxis dataKey="time" stroke={theme.palette.text.secondary} dy={10} />
          <YAxis stroke={theme.palette.text.secondary} dx={-5}>
            <Label
              angle={270}
              position="left"
              style={{ textAnchor: "middle", fill: theme.palette.text.primary }}
            >
              Sales ($)
            </Label>
          </YAxis>
          <Line
            type="monotone"
            dataKey="amount"
            stroke={theme.palette.primary.main}
            dot={false}
          />
        </LineChart>
      </ResponsiveContainer>
    </React.Fragment>
  );
}
