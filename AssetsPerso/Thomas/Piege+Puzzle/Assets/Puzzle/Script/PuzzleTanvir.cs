using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PuzzleTanvir : MonoBehaviour 
{
	public enum TypeOfPuzzle
	{
		DoorOpen,
		PlateformUp
	}
	public TypeOfPuzzle TypePuz = TypeOfPuzzle.DoorOpen;

	public GameObject Door;
	public GameObject Plateform;

	public GameObject First;
	public GameObject Second;


	public static bool OneOk = false;
	public static bool SecOk = false;

	

	public void PullTrigger(Collider col)
	{
		if(OneOk && SecOk)
		{
			switch (TypePuz)
			{
				case TypeOfPuzzle.DoorOpen : 
					Door.SetActive(false);
					TanvirScript.HaveTrigger = true;
				break;
				case TypeOfPuzzle.PlateformUp : 
					Plateform.SetActive(true);
					TanvirScript.HaveTrigger = true;
				break;
				default:
				break;
			}
		}
	}
	/*
	Variante : 
		1 : ajouter des zones qui repulse la caisse pour entraver le joueur
		2 : Faire un labyrinte
		3 : un sans rien
	*/
}
