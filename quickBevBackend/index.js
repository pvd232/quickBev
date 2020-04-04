// --------------------------------------------------------
    // Pull in the libraries
    // --------------------------------------------------------

    const app = require('express')()
    const bodyParser = require('body-parser')

    // --------------------------------------------------------
    // Helpers
    // --------------------------------------------------------

    function uuidv4() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
      });
    }


    // --------------------------------------------------------
    // In-memory database
    // --------------------------------------------------------

    var user_id = null

    var orders = []

    let inventory = [
        {
            id: uuidv4(),
            name: "IPA",
            description: "Bitter.",
            amount: 39.99,
            image: 'drink1'
        },
        {
            id: uuidv4(),
            name: "Reds",
            description: "Taste like apple juice!",
            amount: 29.99,
            image: 'drink2'
        },
        {
            id: uuidv4(),
            name: "Water",
            description: "HYDRATION",
            amount: 29.99,
            image: 'drink3'
        }
    ]


    // --------------------------------------------------------
    // Express Middlewares
    // --------------------------------------------------------

    app.use(bodyParser.json())
    app.use(bodyParser.urlencoded({extended: false}))


    // --------------------------------------------------------
    // Routes
    // --------------------------------------------------------

    app.get('/orders', (req, res) => res.json(orders))

    app.post('/orders', (req, res) => {
        let id = uuidv4()
        user_id = req.body.user_id
        let drink = inventory.find(item => item["id"] === req.body.drink_id)

        if (!drink) {
            return res.json({status: false})
        }

        orders.unshift({id, user_id, drink, status: "Pending"})
        res.json({status: true})
    })

    app.put('/orders/:id', (req, res) => {
        let order = orders.find(order => order["id"] === req.params.id)

        if (!order) {
            return res.json({status: false})
        }

        orders[orders.indexOf(order)]["status"] = req.body.status

        return res.json({status: true})
    })

    app.get('/inventory', (req, res) => res.json(inventory))
    app.get('/', (req, res) => res.json({status: "success"}))


    // --------------------------------------------------------
    // Serve application
    // --------------------------------------------------------

    app.listen(4000, _ => console.log('App listening on port 4000!'))