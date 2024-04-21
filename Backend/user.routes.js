const router = require("express").Router();
const UserController = require('./user.controller');
const TextController = require('./text.controller'); // Import the TextService controller
const TextModel = require('./text.model');

// Route to get completed tasks array
router.get('/completed-tasks/:userId/:topic', async (req, res) => {
    try {
        const { userId, topic } = req.params;
        const textArray = await TextModel.findOne({ userId, topic }, { completed_tasks: 1, _id: 0 }); // Only retrieve completed_tasks array for the specific user and topic
        res.json(textArray);
    } catch (error) {
        console.error("Error getting completed tasks:", error);
        res.status(500).json({ error: 'Internal server error' });
    }
});
router.post("/completed-tasks/:userId/:topic", TextController.storeCompletedTasks);


router.post("/register",UserController.register);

router.post("/login", UserController.login);


router.post("/createText", TextController.createText); // Route for creating text
router.get("/getText/:userId", TextController.getText); // Route for getting text by user ID


module.exports = router;