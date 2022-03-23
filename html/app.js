window.addEventListener("message", function(event) {
    var v = event.data
    switch (v.action) {
        case 'hideBlip':
            $('.contenedor').fadeOut()
            $('.deleteblips').fadeOut()
            $('.formblip').fadeOut()
        break;

        case 'showBlip':
            if (v.admin == true) {
                $('.admin').show()
                $('.contenedor').fadeIn()
                $('.menu').animate({'top':'50%'})
            } else if(v.admin == false) {
                $('.admin').hide()
                $('.contenedor').fadeIn()
                $('.menu').animate({'top':'50%'})
            }

        break;

        case 'deleteBlip':
     
            $('.contenedor').fadeOut()
            $('.deleteblips').fadeIn()

            $('.menudelete').animate({'top':'50%'})
            $('.menudelete img').fadeIn(2000)
        break;

        case 'loadBlipsToDelete':
            let blips = v.totalblips
            $('.blipsDelete').append(`
            <option value="${blips.blipid}">${blips.name}</option>
            `
            )
        break;

        case 'Coords':
            let cordenadas = v.coords
            $('.coordx').val(cordenadas.x.toFixed(2))
            $('.coordy').val(cordenadas.y.toFixed(2))
            $('.coordz').val(cordenadas.z.toFixed(2))
            $('#coords').val(`${cordenadas.x.toFixed(2)} ${cordenadas.y.toFixed(2)} ${cordenadas.z.toFixed(2)}  `)
        break;
    }
});

$(document).keyup((e) => {
    if (e.key === "Escape") {
        setTimeout(() => {
            $.post('https://Roda_BlipsCreator/exit', JSON.stringify({}));
        }, 300);
        let formulario = document.getElementById('formul')
        let formulario2 = document.getElementById('formblip')
        $('.menudelete').css({'width':'35vw', 'height':'27vw'})
        formulario.reset()
        $('#formblip')
            .find('option')
            .remove()
            .end()
            .val('Remove Blip')
        ;

    }
});

$(function () {
    $( ".btnps" ).click(function() {
        if($('#nombre').val() === '' || $('#sprite').val() === '' || $('#color').val() === '' || $('#coords').val() === '') {
            return
        }
        $.post('https://Roda_BlipsCreator/data', JSON.stringify({
            name : $('#nombre').val(),
            sprite: $('#sprite').val(),
            color : $('#color').val(),
            admin : $('.adminval').val(),
            x: $('.coordx').val(),
            y: $('.coordy').val(),
            z: $('.coordz').val(),
        }));
    });

    $( ".boton" ).click(function() {
        setTimeout(() => {
            $.post('https://Roda_BlipsCreator/coords', JSON.stringify({}));
        }, 300);
    });

    $( ".btndelete" ).click(function() {
        setTimeout(() => {
            $.post('https://Roda_BlipsCreator/delete', JSON.stringify({
                isadmin : $('.adminval').val(),
            }));
        }, 300);
        $('.menudelete img').css({'animation':'3s rotar linear infinite'})
        setTimeout(() => {
            $('.menudelete img').hide()
            $('.formblip').show()
            $('.menudelete').css({'width':'15vw', 'height':'12vw'})
        }, 3300);
    });

    $('.BotonDelete').click(function() {
            seleccion = $('#getBlipsSelect').find(":selected").val()
            $.post('https://Roda_BlipsCreator/DeleteBlip', JSON.stringify({
                blipid : seleccion
            }));
    });

    var administrador = true
    $( ".admin" ).click(function() {
        if (administrador == true) {
            $('.adminval').val('yes')
            $('.admin').text('Personal')
            $('.btndelete').text('Delete Admin Blips')
            administrador = false
        } else if(administrador == false) {
            $('.adminval').val('no')
            $('.admin').text('Admin Blips')
            $('.btndelete').text('Delete Blips')
            administrador = true
        }
 
    });

   
});


