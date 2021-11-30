module.exports = (app) => {
    app.get('/', (req, res, next) => {
        res.render('index', {title: 'Index || Bai TH 1'});
    });

    app.get('/signup', (req, res, next) => {
        res.render('user/signup', {title: 'Sign up || Bai TH 1'});
    });

    app.get('/login', (req, res, next) => {
        res.render('user/login', {title: 'Login || Bai TH 1'});
    });
}