$(document).ready(function() {
    let currentPlayerId = null;
    
    $('.tab-button').click(function() {
        $('.tab-button').removeClass('active');
        $(this).addClass('active');
        $('.tab-pane').removeClass('active');
        $('#' + $(this).data('tab')).addClass('active');
    });

    window.addEventListener('message', function(event) {
        if (event.data.type === "openAdminPanel") {
            $('#admin-panel').show();
        } else if (event.data.type === "closeAdminPanel") {
            $('#admin-panel').hide();
        } else if (event.data.type === "updatePlayerList") {
            updatePlayerList(event.data.players);
        } else if (event.data.type === "updateAdminOptions") {
            updateAdminOptions(event.data.options);
        }
    });

    function updatePlayerList(players) {
        const playerList = $('#player-list');
        playerList.empty();
        players.forEach(player => {
            const playerItem = $(`<div class="player-item" data-id="${player.id}">${player.name} (${player.id})</div>`);
            playerList.append(playerItem);
        });
    }

    function updateAdminOptions(options) {
        updateActionButtons('#player-actions', options.playerActions);
        updateActionButtons('#server-actions', options.serverManagement);
        updateActionButtons('#vehicle-actions', options.vehicleOptions);
        updateActionButtons('#dev-actions', options.devTools);
    }

    function updateActionButtons(containerId, actions) {
        const container = $(containerId);
        container.empty();
        actions.forEach(action => {
            const button = $(`<button class="action-button" data-action="${action.id}">${action.label}</button>`);
            container.append(button);
        });
    }

    $(document).on('click', '.player-item', function() {
        $('.player-item').removeClass('selected');
        $(this).addClass('selected');
        currentPlayerId = $(this).data('id');
    });

    $(document).on('click', '.action-button', function() {
        const action = $(this).data('action');
        $.post('https://qb-adminmenu/performAction', JSON.stringify({ 
            action: action, 
            playerId: currentPlayerId 
        }));
    });

    $('#player-search').on('input', function() {
        const searchTerm = $(this).val().toLowerCase();
        $('.player-item').each(function() {
            const playerName = $(this).text().toLowerCase();
            $(this).toggle(playerName.includes(searchTerm));
        });
    });

    $('#close-button').click(function() {
        $.post('https://qb-adminmenu/closeAdminPanel', JSON.stringify({}));
    });
});

