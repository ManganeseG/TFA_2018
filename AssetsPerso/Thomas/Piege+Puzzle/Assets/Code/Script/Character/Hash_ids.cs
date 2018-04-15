using UnityEngine;
using System.Collections;

public class Hash_ids : MonoBehaviour 
{
	// définition des tags de références pour les différents éléments de l'animator
	public int speedFloat;
	public int jumpBool;
	public int hitBool;
	public int launchBool;

	public int idleState;
	public int locomotionState;
	public int jumpState;
	public int launchState;
	public int hitState;


	void Awake () 
	{
		// ID des paramètres
		speedFloat	= Animator.StringToHash ("Speed"); 
		jumpBool	= Animator.StringToHash ("Jump"); 
		hitBool		= Animator.StringToHash ("Hit_up"); 
		launchBool	= Animator.StringToHash ("Launch"); 


		// ID des animations
		idleState 		= Animator.StringToHash ("Base Layer.idle");
		locomotionState = Animator.StringToHash ("Base Layer.locomotion"); 
		jumpState 		= Animator.StringToHash ("Base Layer.jump"); 
		launchState 	= Animator.StringToHash ("Base Layer.launch"); 
		hitState 		= Animator.StringToHash ("UpperBody Layer.hit_up"); 
	}
	
}

