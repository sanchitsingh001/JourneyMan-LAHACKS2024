const TextService = require('./text.services');

exports.createText = async (req, res, next) => {
    try {
        const { userId, topic, journey, start_date, end_date, completed_tasks } = req.body;
        const newText = await TextService.createText(userId, topic, journey, start_date, end_date, completed_tasks);
        res.status(201).json(newText);
    } catch (error) {
        console.error(error);
        next(error);
    }
}

exports.getText = async (req, res, next) => {
    try {
        const { userId } = req.params;
        const textList = await TextService.getText(userId);
        res.json(textList);
    } catch (error) {
        console.error(error);
        next(error);
    }
}
exports.storeCompletedTasks = async (req, res, next) => {
    try {
        const { userId, topic } = req.params;
        const { tasks } = req.body;

        // Call the updated service function to store completed tasks
        await TextService.storeCompletedTasks(userId, topic, tasks);

        res.status(201).json({ message: 'Tasks stored successfully' });
    } catch (error) {
        console.error(error);
        next(error);
    }
}
