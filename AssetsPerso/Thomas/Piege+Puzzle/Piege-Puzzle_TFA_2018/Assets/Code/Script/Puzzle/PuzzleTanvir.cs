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
	
	void Start () 
	{

	}
	
	void Update () 
	{
		
	}

	public void PullTrigger(Collider col)
	{
		if(OneOk && SecOk)
		{
			switch (TypePuz)
			{
				case TypeOfPuzzle.DoorOpen : 
					Door.SetActive(false);
					ImpulseForce.HaveTrigger = true;
				break;
				case TypeOfPuzzle.PlateformUp : 
					Plateform.SetActive(true);
					ImpulseForce.HaveTrigger = true;
				break;
				default:
				break;
			}
		}
	}
}
