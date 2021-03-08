import Dashboard from './dashboard/Dashboard.js';
import { useState, useEffect } from 'react';
import API from '../helpers/Api.js';

const Home = () => {
	const [orders, setOrders] = useState(null);
	const [customers, setCustomers] = useState(null);

	useEffect(() => {
		let mounted = true;
		API.getOrders().then((items) => {
			console.log('items', items);
			if (mounted) {
				setOrders(items);
			}
		});
		API.getCustomers().then((items) => {
			if (mounted) {
				setCustomers(items);
			}
		});
		return () => (mounted = false);
	}, []);
	return <Dashboard orders={orders} customers={customers}></Dashboard>;
	// if (orders) {
	//   return <Dashboard orderArray={orders}></Dashboard>;
	// } else {
	//   return <></>;
	// }
};
export default Home;
