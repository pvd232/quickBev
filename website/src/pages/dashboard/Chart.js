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

export default function Chart(props) {
  const theme = useTheme();
  const data = props.data;
  console.log("data", data);
  // Generate Sales Data
  const createData = (time, amount) => {
    return { time, amount };
  };
  const dataFormatted = [
    createData(`${new Date().getMonth()}/${new Date().getDate()}`, 0),
    // createData("03:00", 300),
    // createData("06:00", 600),
    // createData("09:00", 800),
    // createData("12:00", 1500),
    // createData("15:00", 2000),
    // createData("18:00", 2400),
    // createData("21:00", 2400),
    createData("24:00", undefined),
  ];

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
