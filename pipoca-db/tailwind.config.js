module.exports = {
    purge: {
        content: [
            'views/**/*.ejs',
            'nuxt.config.js',

        ]
    },
    darkMode: false, // or 'media' or 'class'
    theme: {
        extend: {
            colors: {
                red: '#F90F00',
                orange: '#FD4500',
            }
        },
    },
    variants: {
        extend: {},
    },
    plugins: [
        require('@tailwindcss/custom-forms'),
    ],
}