// SPDX-License-Identifier: GPL-3.0

/*
Contrat kurucusu bir kurul gibi davranacak ve seçimi başlatıp bitirecek.
Seçimin başlangıç ve bitiş süresi olacak. Öncesinde ve sonrasında oy kullanılmayacak.
Adaylar sözleşme deploy edilirken girilecek. 
Seçmenler sadece 1 oy kullanacak. Seçmenler cüzdan adresleri ve kimlik numaralarıyla kaydedilecek.
Adaylar da oy kullanabilecek.
Seçim sona erince kurucu toplam oyları açıklayacak ve kazanan belirlenecek. 
Seçim sona ermeden sonuçlar görüntülenmeyecek. 
*/

pragma solidity ^0.8.13;

contract VotingContract {
    
    struct Vote {
        uint x;
        string y;
        address d;
    }



}

