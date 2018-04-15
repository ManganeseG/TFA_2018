/* ----- Références -----
	http://unity3d.com/learn/tutorials/projects/stealth chapitre II player
	http://docs.unity3d.com/ScriptReference/index.html
	doc de ref du cours sur unity de gil : https://docs.google.com/presentation/d/190CjMOwc1hvn8q_hopn5TCpRQyfwQxA2czCGdLl9-g4/edit#slide=id.g6990299ef_04
*/

using UnityEngine;
using System.Collections;

public class characProto_move : MonoBehaviour 
{
// ----- Défintion des variables -----

	public float turnSmoothing = 10f; // rend la rotation du personnage plus souple sur son axe y
	public float speedDampTime = .1f; // permet de diviser les étapes pour parvenir à la vitesse maximale

	private float maxSpeedThershold = 1.00f; // valeur provenant du threshold max de la course dans le blender de locomotion)

	private Animator animator; // référence du component Animator
	private Hash_ids hash; // référence au script  hashs ids

	// index des layers d'anim
	private int base_layerId;
	private int fullBody_layerId;
	private int upperBody_layerId;


// ----- Initialisation -----
	void Awake()
	{
		// assigne les composants de la scene aux variables
		animator = GetComponent<Animator> ();
		hash = GameObject.FindGameObjectWithTag (Tags.gameController).GetComponent<Hash_ids> ();

		// assigne les index des layers
		base_layerId = animator.GetLayerIndex ("Base Layer");
		fullBody_layerId = animator.GetLayerIndex ("FullBody Layer");
		upperBody_layerId = animator.GetLayerIndex ("UpperBody Layer");

		// mets les valeurs par défaut aux différents layers de la scene
		animator.SetLayerWeight (base_layerId, 1f);
		animator.SetLayerWeight (fullBody_layerId, 1f);
		animator.SetLayerWeight (upperBody_layerId, 1f);
	}

// ----- Boucle Principale -----

	void FixedUpdate()
	{
		float horizontal = Input.GetAxis ("Horizontal");
		float vertical = Input.GetAxis ("Vertical");
		bool jump = Input.GetButton ("Fire1");
		bool hit = Input.GetButton ("Fire2");
		bool launch = Input.GetButton ("Fire3");

		CharacterControl (horizontal, vertical);
		CharacterPlayAnim (jump, 	hash.jumpState, 	hash.jumpBool, 	fullBody_layerId);
		CharacterPlayAnim (hit, 	hash.hitState, 		hash.hitBool, 	 upperBody_layerId);
		CharacterPlayAnim (launch, 	hash.launchState,	hash.launchBool, fullBody_layerId);
	}


// ----- Fonctions -----

	// permet de controler la rotation et la vitesse du personnage. Le déplacement se trouve dans l'animation elle meme
	void CharacterControl(float horizontal, float vertical)
	{
		if (horizontal != 0f || vertical != 0f) 
		{
			
			Vector3 targetDirection = new Vector3 (horizontal *-1f, 0f, vertical *-1f);
			
			// calcul des rotations à partir des axes du joypad
			Quaternion targetRotation = Quaternion.LookRotation (targetDirection, Vector3.up);
			Quaternion newRotation = Quaternion.Lerp (transform.rotation, targetRotation, turnSmoothing * Time.deltaTime);
			transform.rotation = newRotation;
			
			// gestion de la vitesse de la locomotion basée sur la longueur du vecteur de direction
			float magnitude = targetDirection.magnitude;
			//animator.SetFloat (hash.speedFloat, maxSpeedThershold * magnitude);
			
			// gestion de la vitesse de la locomotion basée sur l'accumulation de valeur sur le paramètre speed
			animator.SetFloat (hash.speedFloat, maxSpeedThershold * magnitude, speedDampTime, Time.deltaTime);
			
		} 
		else 
		{
			animator.SetFloat (hash.speedFloat, 0f);
		}
	}


	// Empeche la répétition de l'animation. On attend que l'animation soit terminée pour la rejouer a nouveau
	void CharacterPlayAnim(bool play, int hashState, int hashBool, int layerId)
	{
		// test si une animation est jouée dans le layer défini
		if (animator.GetCurrentAnimatorStateInfo(layerId).shortNameHash == hashState)
		{
			// désactive le booléen qui déclenche l'animation
			animator.SetBool (hashBool, false);
		} 
		else
		{
			// si l'animation n'est pas en cours, on active ou pas le booléen pour déclncher l'animation
			animator.SetBool (hashBool, play);
		}
	}


}


